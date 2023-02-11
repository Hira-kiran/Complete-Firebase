// ignore_for_file: file_names
import 'package:complete_firbase/Realtime_Database/addPost.dart';
import 'package:complete_firbase/auth/signupScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;
  final realTimeDbRef = FirebaseDatabase.instance.ref("Post");
  final searchController = TextEditingController();
  final editController = TextEditingController();

  Future<void> editdialogueBox(String message, String id) {
    editController.text = message;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Dialogue Box"),
            content: TextFormField(
              controller: editController,
              decoration: const InputDecoration(hintText: "Edit"),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () {
                    realTimeDbRef.child(id).update({
                      "Message": editController.text.toString()
                    }).then((value) {
                      ToastMessage().toastmsj("Post is Updated");
                    }).onError((error, stackTrace) {
                      ToastMessage().toastmsj(error.toString());
                    });
                    Navigator.pop(context);
                  },
                  child: const Text("Update")),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PostScreen"),
        actions: [
          IconButton(
              onPressed: () {
                auth.signOut().then((value) {
                  Get.to(const SignupScreen());
                });
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      // For fatch data from firbase realtime database
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: TextFormField(
              controller: searchController,
              decoration: const InputDecoration(
                  hintText: "Search", border: OutlineInputBorder()),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: FirebaseAnimatedList(
                query: realTimeDbRef,
                defaultChild: const Text("loading"),
                itemBuilder: (context, snapshot, animation, index) {
                  final message = snapshot.child("Message").value.toString();
                  final id = snapshot.child("id").value.toString();
                  if (searchController.text.isEmpty) {
                    return ListTile(
                        title: Text(snapshot.child("Message").value.toString()),
                        subtitle: Text(snapshot.child("id").value.toString()),
                        trailing: PopupMenuButton(
                          icon: const Icon(Icons.more_vert),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                                child: ListTile(
                              onTap: () {
                                Navigator.pop(context);
                                editdialogueBox(message, id);
                              },
                              title: const Text("Edit"),
                              leading: const Icon(Icons.edit),
                            )),
                            PopupMenuItem(
                                child: ListTile(
                              onTap: () {
                                realTimeDbRef.child(id).remove().then((value) {
                                  ToastMessage().toastmsj("Post is Deleted");
                                });
                                Navigator.pop(context);
                              },
                              title: const Text("Delete"),
                              leading: const Icon(Icons.delete),
                            ))
                          ],
                        ));
                  } else if (message.toLowerCase().contains(
                      searchController.text.toLowerCase().toString())) {
                    return ListTile(
                        title: Text(snapshot.child("Message").value.toString()),
                        subtitle: Text(snapshot.child("id").value.toString()),
                        trailing: PopupMenuButton(
                          icon: const Icon(Icons.more_vert),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                                child: ListTile(
                              onTap: () {
                                Navigator.pop(context);
                                editdialogueBox(message, id);
                              },
                              title: const Text("Edit"),
                              leading: const Icon(Icons.edit),
                            )),
                            PopupMenuItem(
                                child: ListTile(
                              onTap: () {
                                realTimeDbRef.child(id).remove();
                              },
                              title: const Text("Delete"),
                              leading: const Icon(Icons.delete),
                            ))
                          ],
                        ));
                  } else {
                    return Container();
                  }
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const AddPostScreen());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}


  // // For fatch data from firbase realtime database
  //     body: FirebaseAnimatedList(
  //         query: relationalDbRef,
  //         itemBuilder: (context, snapshot, animation, index) {
  //           return ListTile(
  //             title: Text(snapshot.child("Message").value.toString()),
  //             subtitle: Text(snapshot.child("Name").value.toString()),
  //           );
  //         }),