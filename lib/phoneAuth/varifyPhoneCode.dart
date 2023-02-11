// ignore_for_file: file_names

import 'package:complete_firbase/Realtime_Database/postScreen.dart';
import 'package:complete_firbase/auth/signupScreen.dart';
import 'package:complete_firbase/components/containerBtn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VarifyPhoneCode extends StatefulWidget {
  final String verificationId;
  const VarifyPhoneCode({super.key, required this.verificationId});

  @override
  State<VarifyPhoneCode> createState() => _VarifyPhoneCodeState();
}

class _VarifyPhoneCodeState extends State<VarifyPhoneCode> {
  final varifyCodeConroller = TextEditingController();
  final auth = FirebaseAuth.instance;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Varify Phone Code"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            TextFormField(
              controller: varifyCodeConroller,
              decoration: const InputDecoration(hintText: "6 digits Code"),
            ),
            ContainerBtnComp(
                loading: loading,
                text: "Varify",
                onclick: () async {
                  setState(() {
                    loading = true;
                  });
                  final credential = PhoneAuthProvider.credential(
                      verificationId: widget.verificationId,
                      smsCode: varifyCodeConroller.text.toString());

                  try {
                    await auth.signInWithCredential(credential);
                    Get.to(() => const PostScreen());
                    setState(() {
                      loading = false;
                    });
                  } catch (e) {
                    ToastMessage().toastmsj(e.toString());
                    setState(() {
                      loading = false;
                    });
                  }
                }),
          ],
        ),
      ),
    );
  }
}
