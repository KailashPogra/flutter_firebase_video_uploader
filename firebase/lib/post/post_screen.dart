import 'package:firebase/post/add_post.dart';
import 'package:firebase/ui/login.dart';
import 'package:firebase/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final ref = FirebaseDatabase.instance.ref('Post');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final serchFilter = TextEditingController();
  final editController = TextEditingController();
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
        title: Text('post screen'),
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
              MaterialPageRoute(builder: (context) => AddPostScreen()));
        },
        child: Icon(Icons.add),
      ),
      body: Column(children: [
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextFormField(
            controller: serchFilter,
            decoration: const InputDecoration(
                hintText: 'Search', border: OutlineInputBorder()),
            onChanged: (String value) {
              setState(() {});
            },
          ),
        ),
        // fatching data using StreamBuilder
        // Expanded(
        //     child: StreamBuilder(
        //         stream: ref.onValue,
        //         builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
        //           if (!snapshot.hasData) {
        //             return CircularProgressIndicator();
        //           } else {
        //             Map<dynamic, dynamic> map =
        //                 snapshot.data!.snapshot.value as dynamic;
        //             List<dynamic> list = [];
        //             list.clear();
        //             list = map.values.toList();
        //             return ListView.builder(
        //                 itemCount: snapshot.data!.snapshot.children.length,
        //                 itemBuilder: (context, index) {
        //                   return ListTile(
        //                     title: Text(list[index]['title']),
        //                     subtitle: Text(list[index]['id']),
        //                   );
        //                 });
        //           }
        //         })),
        Expanded(
            child: FirebaseAnimatedList(
                query: ref,
                defaultChild: Text('Loading'),
                itemBuilder: (context, snapshot, animation, index) {
                  final title = snapshot.child('title').value.toString();
                  if (serchFilter.text.isEmpty) {
                    return ListTile(
                      title: Text(snapshot.child('title').value.toString()),
                      subtitle: Text(snapshot.child('id').value.toString()),
                      trailing: PopupMenuButton(
                          icon: const Icon(Icons.more_vert),
                          itemBuilder: (context) => [
                                PopupMenuItem(
                                    value: 1,
                                    child: ListTile(
                                      leading: Icon(Icons.edit),
                                      title: Text('Edit'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        showMyDialog(
                                            title,
                                            snapshot
                                                .child('id')
                                                .value
                                                .toString());
                                      },
                                    )),
                                PopupMenuItem(
                                    value: 1,
                                    child: ListTile(
                                      leading: Icon(Icons.delete),
                                      title: Text('Delete'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        ref
                                            .child(snapshot
                                                .child('id')
                                                .value
                                                .toString())
                                            .remove();
                                      },
                                    ))
                              ]),
                    );
                  } else if (title
                      .toLowerCase()
                      .contains(serchFilter.text.toLowerCase().toLowerCase())) {
                    return ListTile(
                      title: Text(snapshot.child('title').value.toString()),
                      subtitle: Text(snapshot.child('id').value.toString()),
                    );
                  } else {
                    return Container();
                  }
                }))
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
                },
                child: Text('Cancel'),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ref
                        .child(id)
                        .update({'title': editController.text.toString()}).then(
                            (value) {
                      Utils().tostMassage('update sucessfull');
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
