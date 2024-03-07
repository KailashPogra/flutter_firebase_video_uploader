import 'package:firebase/utils/utils.dart';
import 'package:firebase/widget/round_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final postController = TextEditingController();
  bool loading = false;
  final databaseref = FirebaseDatabase.instance.ref('Post');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('add post'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              controller: postController,
              maxLines: 4,
              decoration: const InputDecoration(
                  hintText: "what's in your mind? ",
                  border: OutlineInputBorder()),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          RoundButton(
              title: 'Add',
              loading: loading,
              onPress: () {
                setState(() {
                  loading = true;
                });
                String idnum = DateTime.now().microsecondsSinceEpoch.toString();
                databaseref.child(idnum).set({
                  'title': postController.text.toString(),
                  'id': idnum,
                }).then((value) {
                  Utils().tostMassage('sucessfully added');
                  setState(() {
                    loading = false;
                  });
                }).onError((error, stackTrace) {
                  Utils().tostMassage(error.toString());
                  setState(() {
                    loading = false;
                  });
                });
              })
        ],
      ),
    );
  }
}
