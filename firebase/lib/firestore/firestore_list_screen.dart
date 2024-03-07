import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/firestore/add_firestore_data.dart';
import 'package:flutter/material.dart';

import 'package:firebase/ui/login.dart';
import 'package:firebase/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreSceen extends StatefulWidget {
  const FirestoreSceen({super.key});

  @override
  State<FirestoreSceen> createState() => _FirestoreSceenState();
}

class _FirestoreSceenState extends State<FirestoreSceen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final editController = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection('user').snapshots();
  CollectionReference ref1 = FirebaseFirestore.instance.collection('user');
  void logoutUser() async {
    await _auth.signOut().then((value) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => login()));
    }).onError((error, stackTrace) {
      Utils().tostMassage(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout), // Your postfix icon
            onPressed: () {
              // Add your action here
              logoutUser();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => FirestoreDataScreen()));
        },
        child: Icon(Icons.add),
      ),
      body: Column(children: [
        const SizedBox(
          height: 10,
        ),
        Text('Longpress to perform actions'),
        StreamBuilder<QuerySnapshot>(
            stream: fireStore,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return CircularProgressIndicator();
              if (!snapshot.hasData) return Text('Some error');

              return Expanded(
                child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onLongPress: () {
                          showMyDialog(
                              snapshot.data!.docs[index]['title'].toString(),
                              snapshot.data!.docs[index]['id'].toString());
                        },
                        title: Text(
                            snapshot.data!.docs[index]['title'].toString()),
                        subtitle:
                            Text(snapshot.data!.docs[index]['id'].toString()),
                        trailing: Icon(Icons.edit),
                      );
                    }),
              );
            })
      ]),
    );
  }

  Future<void> showMyDialog(String title, String id) async {
    editController.text = title;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Update'),
            content: Container(
              child: TextField(
                controller: editController,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ref1.doc(id).delete();
                },
                child: Text('delete'),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);

                    ref1
                        .doc(id)
                        .update({'title': editController.text.toString()}).then(
                            (value) {
                      Utils().tostMassage('updated');
                    }).onError((error, stackTrace) {
                      Utils().tostMassage(error.toString());
                    });
                  },
                  child: Text('Update')),
            ],
          );
        });
  }
}
