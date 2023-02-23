// ignore_for_file: file_names, prefer_adjacent_string_concatenation

import 'dart:io';
import 'package:complete_firbase/auth/signupScreen.dart';
import 'package:complete_firbase/components/containerBtn.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_pdfview/flutter_pdfview.dart';

class UploadFilesScreen extends StatefulWidget {
  const UploadFilesScreen({super.key});

  @override
  State<UploadFilesScreen> createState() => _UploadFilesScreenState();
}

class _UploadFilesScreenState extends State<UploadFilesScreen> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final firebaseRealtmDBref = FirebaseDatabase.instance.ref("Post");
  bool loading = false;
  File? pdfFile;
  // final picker = ImagePicker();

  Future imagePickerGallery() async {
    final result = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ["pdf", "doc", "jpg"]);

    setState(() {
      if (result != null) {
        final filePath = result.files.single.path!;
        pdfFile = File(filePath);
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                imagePickerGallery();
              },
              child: Center(
                child: Container(
                  /* height: 170,
                  width: 170, */
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20)),
                  child: pdfFile != null
                      ? PDFView(
                          filePath: pdfFile!.path,
                        )
                      /*  Image.file(
                          pdfFile!.absolute,
                          fit: BoxFit.fill,
                        ) */
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
                text: "Upload File",
                onclick: () async {
                  setState(() {
                    loading = true;
                  });
                  firebase_storage.Reference ref = firebase_storage
                      .FirebaseStorage.instance
                      // ignore: prefer_interpolation_to_compose_strings
                      .ref("/PDF Books/" +
                          DateTime.now().millisecondsSinceEpoch.toString());
                  firebase_storage.UploadTask uploadTask =
                      ref.putFile(pdfFile!.absolute);
                  Future.value(uploadTask).then((value) async {
                    var newUrl = await ref.getDownloadURL();
                    final id = DateTime.now().millisecondsSinceEpoch.toString();
                    firebaseRealtmDBref.child(id).set(
                        {"id": id, "Message": newUrl.toString()}).then((value) {
                      setState(() {
                        loading = false;
                      });
                      ToastMessage().toastmsj("File is Uploaded");
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
      ),
    );
  }
}
