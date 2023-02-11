// ignore_for_file: file_names

import 'package:complete_firbase/auth/signupScreen.dart';
import 'package:complete_firbase/components/containerBtn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Realtime_Database/postScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
        title: const Text("Login Screen"),
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
                        return "please enter your Email";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: const InputDecoration(label: Text("Password")),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "please enter your password";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ContainerBtnComp(
                text: "Login",
                loading: loading,
                onclick: () {
                  if (formKey.currentState!.validate()) {
                    setState(() {
                      loading = true;
                    });
                    _auth
                        .signInWithEmailAndPassword(
                            email: emailController.text.toString(),
                            password: passwordController.text.toString())
                        .then((value) {
                      setState(() {
                        loading = false;
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PostScreen()));
                      return ToastMessage().toastmsj("Login Successfully");
                    }).onError((error, stackTrace) {
                      setState(() {
                        loading = false;
                      });
                      return ToastMessage().toastmsj(error.toString());
                    });
                  }
                }),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account?",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(const SignupScreen());
                  },
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        decoration: TextDecoration.underline),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
