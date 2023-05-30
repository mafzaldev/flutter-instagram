import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_instagram/providers/user_provider.dart';
import 'package:flutter_instagram/services/fire_store.dart';
import 'package:flutter_instagram/utils/app_colors.dart';
import 'package:flutter_instagram/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  bool _isUploading = false;
  Uint8List? _image;
  final TextEditingController _captionController = TextEditingController();

  uploadPost(String uid, String username, String profImage) async {
    setState(() {
      _isUploading = true;
    });

    String result = await FireStoreService()
        .uploadPost(_captionController.text, _image!, uid, username, profImage);
    if (result == "success") {
      Utils.showToast("Post uploaded!");
      setState(() {
        _image = null;
        _captionController.clear();
        _isUploading = false;
      });
    } else {
      Utils.showToast(result);
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: const Text("Create Post"),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Take a Photo"),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List image = await Utils.pickImage(ImageSource.camera);
                  setState(() {
                    _image = image;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Pick from gallery"),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List image = await Utils.pickImage(ImageSource.gallery);
                  setState(() {
                    _image = image;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    return _image == null
        ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            IconButton(
              onPressed: () => _selectImage(context),
              icon: const Icon(
                Icons.upload,
                size: 50,
                color: Colors.grey,
              ),
            ),
            const Text(
              "Click on the icon to\n upload image",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 20),
            ),
          ])
        : Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.mobileBackgroundColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _image = null;
                  });
                },
              ),
              title: const Text("Add Post"),
              actions: [
                TextButton(
                  onPressed: () => uploadPost(userProvider.user.uid,
                      userProvider.user.username, userProvider.user.photoUrl),
                  child: const Text(
                    "Post",
                    style: TextStyle(
                      color: AppColors.blueColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                _isUploading
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: LinearProgressIndicator(),
                      )
                    : const SizedBox(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(userProvider.user.photoUrl),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: TextField(
                        controller: _captionController,
                        decoration: const InputDecoration(
                          hintText: "Write a caption...",
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      width: 45,
                      height: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: MemoryImage(_image!),
                                fit: BoxFit.contain,
                                alignment: FractionalOffset.topCenter),
                          ),
                        ),
                      ),
                    ),
                    const Divider()
                  ],
                )
              ],
            ));
  }
}
