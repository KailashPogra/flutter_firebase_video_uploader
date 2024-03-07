import 'dart:io';

import 'package:firebase/utils/utils.dart';
import 'package:firebase/widget/round_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  bool loading = false;
  File? _image;
  final picker = ImagePicker();

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  // For storing image paths
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref('post');
  Future getImageGallery() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('no image picked');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: InkWell(
              onTap: () {
                getImageGallery();
              },
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.amberAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _image != null
                    ? Image.file(_image!.absolute)
                    : Icon(Icons.image),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: RoundButton(
                loading: loading,
                title: 'upload',
                onPress: () async {
                  setState(() {
                    loading = true;
                  });
                  firebase_storage.Reference ref = firebase_storage
                      .FirebaseStorage.instance
                      .ref('/kailash/' +
                          DateTime.now().microsecondsSinceEpoch.toString());
                  firebase_storage.UploadTask uploadTask =
                      ref.putFile(_image!.absolute);
                  Future.value(uploadTask).then((value) async {
                    var newUrl = await ref.getDownloadURL();
                    databaseRef
                        .child('1')
                        .set({'id': '12345', 'title': newUrl.toString()}).then(
                            (value) {
                      setState(() {
                        loading = false;
                      });
                      Utils().tostMassage('Uploaded');
                    }).onError((error, stackTrace) {
                      setState(() {
                        loading = false;
                      });
                      Utils().tostMassage(error.toString());
                    });
                  }).onError((error, stackTrace) {
                    setState(() {
                      loading = false;
                    });
                    Utils().tostMassage(error.toString());
                    print("obgjfjdffdfj" + error.toString());
                  });
                }),
          )
        ],
      ),
    );
  }
}
