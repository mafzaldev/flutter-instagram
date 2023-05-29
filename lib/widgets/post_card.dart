// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_instagram/utils/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage("https://picsum.photos/200"),
              ),
              const Expanded(
                  child: Padding(
                padding: EdgeInsets.only(
                  left: 8,
                ),
                child: Text(
                  "Username",
                  style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              )),
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: ListView(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shrinkWrap: true,
                              children: [
                                InkWell(
                                  onTap: () {},
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
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.35,
          width: double.infinity,
          child: Image.network(
            "https://picsum.photos/200",
            fit: BoxFit.cover,
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                "assets/svgs/Like.svg",
                color: AppColors.primaryColor,
                height: 28,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                "assets/svgs/Comment.svg",
                color: AppColors.primaryColor,
                height: 30,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                "assets/svgs/Share.svg",
                color: AppColors.primaryColor,
                height: 32,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                "assets/svgs/Bookmark.svg",
                color: AppColors.primaryColor,
                height: 32,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("1221 likes",
                  style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold)),
              SizedBox(
                width: double.infinity,
                child: RichText(
                  text: const TextSpan(children: [
                    TextSpan(
                        text: "Username",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                      text:
                          " Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
                    )
                  ]),
                ),
              ),
              InkWell(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: const Text(
                    "View all 200 comments",
                    style: TextStyle(
                        fontSize: 16, color: AppColors.secondaryColor),
                  ),
                ),
              ),
              const Text(
                "22/12/2020",
                style: TextStyle(fontSize: 16, color: AppColors.secondaryColor),
              )
            ],
          ),
        )
      ]),
    );
  }
}
