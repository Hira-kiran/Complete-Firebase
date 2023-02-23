// ignore_for_file: file_names

import 'package:complete_firbase/auth/forgortPassword.dart';
import 'package:complete_firbase/phoneAuth/loginWithPhoneNo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../components/containerBtn.dart';
import 'loginScreen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool loading = false;
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Signup Screen"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(label: Text("Email")),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "please enter your email";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: passwordController,
                    decoration: const InputDecoration(label: Text("Password")),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "please enter your password";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(const ForgotPaswordScreen());
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(left: 210),
                      child: Text("Forgot Password"),
                    ),
                  )
                ],
              ),
            ),
            ContainerBtnComp(
              text: "Sign Up",
              loading: loading,
              onclick: () {
                if (formKey.currentState!.validate()) {
                  setState(() {
                    loading = true;
                  });
                  _auth
                      .createUserWithEmailAndPassword(
                          email: emailController.text.toString(),
                          password: passwordController.text.toString())
                      .then((value) {
                    setState(() {
                      loading = false;
                    });
                    return ToastMessage().toastmsj("Singup Successfully");
                  }).onError((error, stackTrace) {
                    setState(() {
                      loading = false;
                    });
                    return ToastMessage().toastmsj(error.toString());
                  });
                }
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have an account?",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(const LoginScreen());
                  },
                  child: const Text(
                    "Log In",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        decoration: TextDecoration.underline),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                Get.to(() => const LoginWithPhoneNumber());
              },
              child: Container(
                height: 50,
                width: 300,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.green,
                    )),
                child: const Center(child: Text("Login With Phone number")),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ToastMessage {
  void toastmsj(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color.fromARGB(255, 184, 78, 68),
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
