// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complete_firbase/auth/signupScreen.dart';
import 'package:complete_firbase/components/containerBtn.dart';
import 'package:flutter/material.dart';

class AddFirestoreData extends StatefulWidget {
  const AddFirestoreData({super.key});

  @override
  State<AddFirestoreData> createState() => _AddFirestoreDataState();
}

class _AddFirestoreDataState extends State<AddFirestoreData> {
  final firestoreDB = FirebaseFirestore.instance.collection("user");
  final postController = TextEditingController();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Firestire Data Screen"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: postController,
              maxLines: 5,
              decoration: const InputDecoration(
                  hintText: "Enter Your Message", border: OutlineInputBorder()),
            ),
            ContainerBtnComp(
                loading: loading,
                text: "Post",
                onclick: () {
                  setState(() {
                    loading = true;
                  });
                  final id = DateTime.now().millisecondsSinceEpoch.toString();
                  firestoreDB.doc(id).set({
                    "Message": postController.text.toString(),
                    "id": id
                  }).then((value) {
                    ToastMessage().toastmsj("Post is Added");
                    setState(() {
                      loading = false;
                    });
                  }).onError((error, stackTrace) {
                    ToastMessage().toastmsj(error.toString());
                    setState(() {
                      loading = false;
                    });
                  });
                }),
          ],
        ),
      ),
    );
  }
}
