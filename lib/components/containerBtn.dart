// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';

class ContainerBtnComp extends StatelessWidget {
  String text;
  VoidCallback onclick;
  bool loading;
  ContainerBtnComp(
      {super.key,
      required this.text,
      required this.onclick,
      this.loading = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InkWell(
        onTap: onclick,
        child: Container(
          height: 50,
          width: 300,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.blue),
          child: Center(
              child: loading == true
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : Text(
                      text,
                      style: const TextStyle(color: Colors.white),
                    )),
        ),
      ),
    );
  }
}
