// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/models/user.dart';
import 'package:flutter_instagram/providers/user_provider.dart';
import 'package:flutter_instagram/screens/comments_screen.dart';
import 'package:flutter_instagram/services/fire_store.dart';
import 'package:flutter_instagram/utils/app_colors.dart';
import 'package:flutter_instagram/utils/utils.dart';
import 'package:flutter_instagram/widgets/like_animation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final postDetails;

  const PostCard({super.key, required this.postDetails});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentsLen = 0;

  @override
  void initState() {
    super.initState();
    getComments();
  }

  void getComments() async {
    try {
      QuerySnapshot commentsSnapshot = await FirebaseFirestore.instance
          .collection("posts")
          .doc(widget.postDetails["postId"])
          .collection("comments")
          .get();
      setState(() {
        commentsLen = commentsSnapshot.docs.length;
      });
    } catch (e) {
      Utils.showToast(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).user;

    return Container(
      color: AppColors.mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(widget.postDetails["profImage"]),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(
                  left: 8,
                ),
                child: Text(
                  widget.postDetails["username"],
                  style: const TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              )),
              widget.postDetails["uid"] == user.uid
                  ? IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: ListView(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shrinkWrap: true,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        Navigator.pop(context);
                                        final result = await FireStoreService()
                                            .deletePost(
                                                widget.postDetails["postId"]);
                                        if (result == "success") {
                                          Utils.showToast("Post deleted");
                                        } else {
                                          Utils.showToast(
                                              "Something went wrong");
                                        }
                                      },
                                      child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 16),
                                          child: const Text("Delete")),
                                    )
                                  ],
                                ),
                              );
                            });
                      },
                      icon: const Icon(
                        Icons.more_vert,
                        color: AppColors.primaryColor,
                      ))
                  : const SizedBox()
            ],
          ),
        ),
        GestureDetector(
          onDoubleTap: () async {
            await FireStoreService().likePost(widget.postDetails["postId"],
                user.uid, widget.postDetails["likes"]);
            setState(() {
              isLikeAnimating = true;
            });
          },
          child: Stack(alignment: Alignment.center, children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              width: double.infinity,
              child: Image.network(
                widget.postDetails["postUrl"],
                fit: BoxFit.cover,
              ),
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isLikeAnimating ? 1 : 0,
              child: LikeAnimation(
                isAnimating: isLikeAnimating,
                onEnd: () {
                  setState(() {
                    isLikeAnimating = false;
                  });
                },
                duration: const Duration(milliseconds: 400),
                child: const Icon(
                  Icons.favorite,
                  size: 120,
                ),
              ),
            )
          ]),
        ),
        Row(
          children: [
            LikeAnimation(
              isAnimating: widget.postDetails["likes"].contains(user.uid),
              smallLike: true,
              child: IconButton(
                  onPressed: () async {
                    await FireStoreService().likePost(
                        widget.postDetails["postId"],
                        user.uid,
                        widget.postDetails["likes"]);
                  },
                  icon: widget.postDetails["likes"].contains(user.uid)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 28,
                        )
                      : const Icon(
                          Icons.favorite_border_outlined,
                          color: AppColors.primaryColor,
                          size: 28,
                        )),
            ),
            IconButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CommentsScreen(
                            postId: widget.postDetails["postId"],
                          ))),
              icon: SvgPicture.asset(
                "assets/svgs/Comment.svg",
                color: AppColors.primaryColor,
                height: 28,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                "assets/svgs/Share.svg",
                color: AppColors.primaryColor,
                height: 30,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                "assets/svgs/Bookmark.svg",
                color: AppColors.primaryColor,
                height: 30,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${widget.postDetails["likes"].length} likes',
                  style: const TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold)),
              SizedBox(
                width: double.infinity,
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: widget.postDetails["username"],
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                      text: ' ${widget.postDetails["caption"]}',
                    )
                  ]),
                ),
              ),
              InkWell(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    'View all $commentsLen comment(s)',
                    style: const TextStyle(
                        fontSize: 16, color: AppColors.secondaryColor),
                  ),
                ),
              ),
              Text(
                DateFormat.yMMMd()
                    .format(widget.postDetails["datePublished"].toDate()),
                style: const TextStyle(
                    fontSize: 16, color: AppColors.secondaryColor),
              )
            ],
          ),
        )
      ]),
    );
  }
}
