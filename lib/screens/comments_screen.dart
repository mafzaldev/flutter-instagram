import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/models/user.dart';
import 'package:flutter_instagram/providers/user_provider.dart';
import 'package:flutter_instagram/services/fire_store.dart';
import 'package:flutter_instagram/utils/app_colors.dart';
import 'package:flutter_instagram/utils/utils.dart';
import 'package:flutter_instagram/widgets/comment_card.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatefulWidget {
  final String postId;

  const CommentsScreen({super.key, required this.postId});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mobileBackgroundColor,
        title: const Text("Comments"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("posts")
            .doc(widget.postId)
            .collection("comments")
            .orderBy("datePublished", descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ));
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return CommentCard(
                  commentDetails: snapshot.data!.docs[index].data(),
                );
              });
        },
      ),
      bottomNavigationBar: SafeArea(
          child: Container(
        height: kToolbarHeight,
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        padding: const EdgeInsets.only(left: 16, right: 18),
        child: Row(children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              user.photoUrl,
            ),
            radius: 20,
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(right: 8.0, left: 16),
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                  hintText: "Comment as ${user.username}",
                  border: InputBorder.none),
            ),
          )),
          TextButton(
            onPressed: () async {
              if (_commentController.text.isEmpty) return;
              final result = await FireStoreService().postComment(
                  widget.postId,
                  user.uid,
                  user.username,
                  _commentController.text,
                  user.photoUrl);

              if (result == "success") {
                Utils.showToast("Comment posted!");
                setState(() {
                  _commentController.clear();
                });
              } else {
                Utils.showToast(result);
                setState(() {
                  _commentController.clear();
                });
              }
            },
            child: const Text(
              "Post",
              style: TextStyle(color: AppColors.blueColor),
            ),
          )
        ]),
      )),
    );
  }
}
