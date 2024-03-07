import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/utils/utils.dart';
import 'package:firebase/widget/round_button.dart';

import 'package:flutter/material.dart';

class FirestoreDataScreen extends StatefulWidget {
  const FirestoreDataScreen({super.key});

  @override
  State<FirestoreDataScreen> createState() => _FirestoreDataScreenState();
}

class _FirestoreDataScreenState extends State<FirestoreDataScreen> {
  final postController = TextEditingController();
  bool loading = false;
  final fireStore = FirebaseFirestore.instance.collection('user');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('add firestore data'),
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
                String id = DateTime.now().millisecondsSinceEpoch.toString();
                fireStore.doc(id).set({
                  "title": postController.text.toString(),
                  "id": id,
                }).then((value) {
                  setState(() {
                    loading = false;
                  });

                  Utils().tostMassage('success');
                }).onError((error, stackTrace) {
                  setState(() {
                    loading = false;
                  });
                  Utils().tostMassage(error.toString());
                });
              })
        ],
      ),
    );
  }
}
