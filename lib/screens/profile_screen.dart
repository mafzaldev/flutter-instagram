// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/screens/login_screen.dart';
import 'package:flutter_instagram/services/fire_auth.dart';
import 'package:flutter_instagram/services/fire_store.dart';
import 'package:flutter_instagram/utils/app_colors.dart';
import 'package:flutter_instagram/utils/utils.dart';
import 'package:flutter_instagram/widgets/follow_button.dart';
import 'package:flutter_instagram/widgets/stats_column.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userDetails = {};
  int postLength = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getProfileData();
  }

  getProfileData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final userDetailsSnap = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.uid)
          .get();

      final postLen = await FirebaseFirestore.instance
          .collection("posts")
          .where("uid", isEqualTo: widget.uid)
          .get();
      setState(() {
        userDetails = userDetailsSnap.data()!;
        postLength = postLen.docs.length;
        followers = userDetailsSnap.data()!['followers'].length;
        following = userDetailsSnap.data()!['following'].length;
        isFollowing = userDetailsSnap
            .data()!['followers']
            .contains(FirebaseAuth.instance.currentUser!.uid);
      });
    } catch (e) {
      Utils.showToast(e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
            color: AppColors.primaryColor,
          ))
        : Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.mobileBackgroundColor,
              title: Text(
                userDetails["username"],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage:
                                NetworkImage(userDetails["photoUrl"]),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    StatsColumn(
                                      label: "Posts",
                                      value: postLength.toString(),
                                    ),
                                    StatsColumn(
                                      label: "Followers",
                                      value: followers.toString(),
                                    ),
                                    StatsColumn(
                                      label: "Following",
                                      value: following.toString(),
                                    ),
                                  ],
                                ),
                                FirebaseAuth.instance.currentUser!.uid ==
                                        widget.uid
                                    ? FollowButton(
                                        backgroundColor:
                                            AppColors.mobileBackgroundColor,
                                        borderColor: AppColors.secondaryColor,
                                        text: "Sign out",
                                        textColor: AppColors.primaryColor,
                                        function: () async {
                                          await FireAuthService().signOut();
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const LoginScreen()));
                                        },
                                      )
                                    : isFollowing
                                        ? FollowButton(
                                            backgroundColor: Colors.white,
                                            textColor: Colors.black,
                                            borderColor: Colors.grey,
                                            text: "Unfollow",
                                            function: () async {
                                              await FireStoreService()
                                                  .followUser(
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid,
                                                      userDetails["uid"]);
                                              setState(() {
                                                isFollowing = false;
                                                followers--;
                                              });
                                            },
                                          )
                                        : FollowButton(
                                            backgroundColor:
                                                AppColors.blueColor,
                                            textColor: AppColors.primaryColor,
                                            borderColor: AppColors.blueColor,
                                            text: "Follow",
                                            function: () async {
                                              await FireStoreService()
                                                  .followUser(
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid,
                                                      userDetails["uid"]);
                                              setState(() {
                                                isFollowing = true;
                                                followers++;
                                              });
                                            },
                                          )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 12,
                        ),
                        child: Text(
                          userDetails["username"],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 1,
                        ),
                        child: Text(
                          userDetails["bio"],
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection("posts")
                        .where("uid", isEqualTo: widget.uid)
                        .get(),
                    builder: (context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ));
                      }
                      return GridView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 1.5,
                            childAspectRatio: 1,
                          ),
                          itemBuilder: (context, index) {
                            DocumentSnapshot snap = snapshot.data!.docs[index];
                            return Image(
                              image: NetworkImage(snap['postUrl']),
                              fit: BoxFit.cover,
                            );
                          });
                    }),
              ],
            ),
          );
  }
}
