import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatefulWidget {
  final commentDetails;
  const CommentCard({super.key, this.commentDetails});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(children: [
        CircleAvatar(
          backgroundImage: NetworkImage(widget.commentDetails["profilePic"]),
          radius: 20,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: widget.commentDetails["username"],
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                      text: ' ${widget.commentDetails["comment"]}',
                    )
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    DateFormat.yMMMd().format(
                        widget.commentDetails["datePublished"].toDate()),
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Padding(
            padding: EdgeInsets.all(8),
            child: Icon(
              Icons.favorite_border,
              size: 16,
            ))
      ]),
    );
  }
}
