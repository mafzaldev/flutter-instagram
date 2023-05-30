import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_instagram/models/user.dart';
import 'package:flutter_instagram/providers/user_provider.dart';
import 'package:flutter_instagram/screens/profile_screen.dart';
import 'package:flutter_instagram/utils/app_colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isShowUsers = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).user;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.mobileBackgroundColor,
          title: TextFormField(
            controller: _searchController,
            decoration: const InputDecoration(
                hintText: "Search for a user...", border: InputBorder.none),
            onFieldSubmitted: (String value) {
              setState(() {
                isShowUsers = true;
              });
            },
          ),
        ),
        body: isShowUsers
            ? FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection("users")
                    .where("username",
                        isGreaterThanOrEqualTo: _searchController.text)
                    .get(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ));
                  }
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        if (snapshot.data!.docs[index]["uid"] == user.uid) {
                          return const SizedBox();
                        }
                        return Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfileScreen(
                                        uid: snapshot.data!.docs[index]
                                            ["uid"]))),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  snapshot.data!.docs[index]["photoUrl"] ?? ""),
                            ),
                            title: Text(snapshot.data!.docs[index]["username"]),
                          ),
                        );
                      });
                })
            : FutureBuilder(
                future: FirebaseFirestore.instance.collection("posts").get(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ));
                  }
                  return StaggeredGridView.countBuilder(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return Image.network(
                        snapshot.data!.docs[index]["postUrl"],
                        fit: BoxFit.cover,
                      );
                    },
                    staggeredTileBuilder: ((index) => StaggeredTile.count(
                        (index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1)),
                  );
                }));
  }
}
