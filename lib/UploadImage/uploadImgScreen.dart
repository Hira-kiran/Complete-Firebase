// ignore_for_file: file_names, prefer_adjacent_string_concatenation

import 'dart:io';
import 'package:complete_firbase/auth/signupScreen.dart';
import 'package:complete_firbase/components/containerBtn.dart';
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
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final firebaseRealtmDBref = FirebaseDatabase.instance.ref("Post");
  bool loading = false;
  File? image;
  final picker = ImagePicker();

  Future imagePickerGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        ToastMessage().toastmsj("No Image Picked");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload image Screen"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              imagePickerGallery();
            },
            child: Center(
              child: Container(
                height: 170,
                width: 170,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                child: image != null
                    ? Image.file(
                        image!.absolute,
                        fit: BoxFit.fill,
                      )
                    : const Icon(
                        Icons.image,
                        color: Colors.white,
                        size: 30,
                      ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ContainerBtnComp(
              loading: loading,
              text: "Upload Image",
              onclick: () async {
                setState(() {
                  loading = true;
                });
                firebase_storage.Reference ref = firebase_storage
                    .FirebaseStorage.instance
                    // ignore: prefer_interpolation_to_compose_strings
                    .ref("/Hirakiran/" +
                        DateTime.now().millisecondsSinceEpoch.toString());
                firebase_storage.UploadTask uploadTask =
                    ref.putFile(image!.absolute);
                Future.value(uploadTask).then((value) async {
                  var newUrl = await ref.getDownloadURL();
                  final id = DateTime.now().millisecondsSinceEpoch.toString();
                  firebaseRealtmDBref.child(id).set(
                      {"id": id, "Message": newUrl.toString()}).then((value) {
                    setState(() {
                      loading = false;
                    });
                    ToastMessage().toastmsj("Post is Uploaded");
                  }).onError((error, stackTrace) {
                    setState(() {
                      loading = false;
                    });
                    ToastMessage().toastmsj(error.toString());
                  });
                }).onError((error, stackTrace) {
                  ToastMessage().toastmsj(error.toString());
                });
              })
        ],
      ),
    );
  }
}
