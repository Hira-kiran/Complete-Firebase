// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complete_firbase/auth/signupScreen.dart';
import 'package:complete_firbase/fireStoreDatabase/addFirestoeData.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FirestoreDBScreeen extends StatefulWidget {
  const FirestoreDBScreeen({super.key});

  @override
  State<FirestoreDBScreeen> createState() => _FirestoreDBScreeenState();
}

class _FirestoreDBScreeenState extends State<FirestoreDBScreeen> {
  final firestoreDB = FirebaseFirestore.instance.collection("user").snapshots();
  final collectionRef = FirebaseFirestore.instance.collection("user");
  final searchController = TextEditingController();
  final editController = TextEditingController();
  Future<void> dialogueFun(String msg, String id) {
    editController.text = msg;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Update"),
            content: TextFormField(
              controller: editController,
              decoration: const InputDecoration(
                  hintText: "Edit", border: OutlineInputBorder()),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () {
                    collectionRef.doc(id).update({
                      "Message": editController.text.toString()
                    }).then((value) {
                      ToastMessage().toastmsj("Post Updated");
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
        title: const Text("Firestore Database"),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              controller: searchController,
              decoration: const InputDecoration(
                  hintText: "Search", border: OutlineInputBorder()),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: firestoreDB,
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Text("Error");
                  } else {
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final msg =
                              snapshot.data!.docs[index]["Message"].toString();
                          final id =
                              snapshot.data!.docs[index]["id"].toString();
                          if (searchController.text.isEmpty) {
                            return ListTile(
                              title: Text(snapshot.data!.docs[index]["Message"]
                                  .toString()),
                              subtitle: Text(
                                  snapshot.data!.docs[index]["id"].toString()),
                              trailing: PopupMenuButton(
                                icon: const Icon(Icons.more_vert),
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                      child: ListTile(
                                    onTap: () {
                                      Navigator.pop(context);
                                      dialogueFun(msg, id);
                                    },
                                    title: const Text(
                                      "Edit",
                                    ),
                                    leading: const Icon(Icons.edit),
                                  )),
                                  PopupMenuItem(
                                      child: ListTile(
                                    onTap: () {
                                      collectionRef.doc(id).delete();
                                      Navigator.pop(context);
                                    },
                                    title: const Text(
                                      "Delete",
                                    ),
                                    leading: const Icon(Icons.delete),
                                  )),
                                ],
                              ),
                            );
                          } else if (msg
                              .toLowerCase()
                              .contains(searchController.text.toLowerCase())) {
                            return ListTile(
                              title: Text(snapshot.data!.docs[index]["Message"]
                                  .toString()),
                              subtitle: Text(
                                  snapshot.data!.docs[index]["id"].toString()),
                              trailing: PopupMenuButton(
                                icon: const Icon(Icons.more_vert),
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                      child: ListTile(
                                    onTap: () {
                                      Navigator.pop(context);
                                      dialogueFun(msg, id);
                                    },
                                    title: const Text(
                                      "Edit",
                                    ),
                                    leading: const Icon(Icons.edit),
                                  )),
                                  PopupMenuItem(
                                      child: ListTile(
                                    onTap: () {
                                      collectionRef.doc(id).delete();
                                      Navigator.pop(context);
                                    },
                                    title: const Text(
                                      "Delete",
                                    ),
                                    leading: const Icon(Icons.delete),
                                  )),
                                ],
                              ),
                            );
                          } else {
                            return Container();
                          }
                        });
                  }
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(const AddFirestoreData());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}


//***********************For Fatch data***************** */
// StreamBuilder<QuerySnapshot>(
//           stream: firestoreDB,
//           builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//             if (!snapshot.hasData) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return const Text("Error");
//             }else{
//               return ListView.builder(
//                   itemCount: snapshot.data!.docs.length,
//                   itemBuilder: (context, index) {
//                     return ListTile(
//                       title: Text(
//                           snapshot.data!.docs[index]["Message"].toString()),
//                     );
//                   });
//             }
           
//           }),