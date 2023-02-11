// ignore_for_file: file_names

import 'package:complete_firbase/components/containerBtn.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../auth/signupScreen.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final addPostController = TextEditingController();
  final realTimeDbRef = FirebaseDatabase.instance.ref("Post");
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add post")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            TextFormField(
                controller: addPostController,
                maxLines: 5,
                decoration: InputDecoration(
                    hintText: "Whats in your mind?",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)))),
            const SizedBox(
              height: 50,
            ),
            ContainerBtnComp(
                loading: loading,
                text: "Add Post",
                onclick: () {
                  setState(() {
                    loading = true;
                  });

                  final id = DateTime.now().millisecondsSinceEpoch.toString();
                  realTimeDbRef.child(id).set({
                    "id": id,
                    "Message": addPostController.text.toString(),
                  }).then((value) {
                    setState(() {
                      loading = false;
                    });
                    ToastMessage().toastmsj("Post is Added");
                  }).onError((error, stackTrace) {
                    setState(() {
                      loading = false;
                    });
                    ToastMessage().toastmsj(error.toString());
                  });
                })
          ],
        ),
      ),
    );
  }
}
