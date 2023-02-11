// ignore_for_file: file_names

import 'package:complete_firbase/phoneAuth/varifyPhoneCode.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../auth/signupScreen.dart';
import '../components/containerBtn.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({super.key});

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  bool loading = false;
  final phoneController = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login With Phoneno"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(hintText: "+92 3782892882"),
            ),
            const SizedBox(
              height: 50,
            ),
            ContainerBtnComp(
              loading: loading,
              text: "Login",
              onclick: () {
                setState(() {
                  loading = true;
                });
                auth.verifyPhoneNumber(
                    phoneNumber: phoneController.text,
                    verificationCompleted: (phoneAuthCredential) {
                      setState(() {
                        loading = false;
                      });
                    },
                    verificationFailed: (error) {
                      setState(() {
                        loading = false;
                      });
                      ToastMessage().toastmsj(error.toString());
                    },
                    codeSent: (verificationId, forceResendingToken) {
                      setState(() {
                        loading = false;
                      });
                      Get.to(() => VarifyPhoneCode(
                            verificationId: verificationId,
                          ));
                    },
                    codeAutoRetrievalTimeout: (verificationId) {
                      setState(() {
                        loading = false;
                      });
                      ToastMessage().toastmsj(verificationId.toString());
                    });
              },
            )
          ],
        ),
      ),
    );
  }
}


//keytool -list -v -keystore "\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android

// Login With phone
// for SHA (Run the command that is visible on top)
// if the command is not working then u run  following two commands that is given below in terminal
// cd andriod
//.\gradlew

//then u easily get your SHA key
