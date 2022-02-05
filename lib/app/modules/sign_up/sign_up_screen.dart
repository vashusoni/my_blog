// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:my_blog/app/modules/create_board/create_new_blog.dart';
import 'package:my_blog/app/modules/sign_in/sign_in_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Form(
        key: signUpFormKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
              ),
              SizedBox(
                  width: 200,
                  child: Image.asset('assets/images/blog_icon.png')),
              Text(
                'MYBLOG',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(.6)),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'With a few simple actions, you can join us',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(.6)),
              ),
              SizedBox(
                height: 100,
              ),
              Text(
                'SignUp Here',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 55,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    onSaved: (value) {
                      email = value!;
                    },
                    validator: (value) {
                      return validateEmail(value!);
                    },
                    autofocus: false,
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 55,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    onSaved: (value) {
                      password = value!;
                    },
                    validator: (value) {
                      return validatePassword(value!);
                    },
                    autofocus: false,
                    keyboardType: TextInputType.text,
                    controller: passwordController,
                    decoration: InputDecoration(
                      hintText: 'password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                child: Text('SignUp'),
                onPressed: () {
                  signUpWithEmailAndPassword();
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.black.withOpacity(.2),
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 13),
                    textStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              ),
              SizedBox(
                height: 30,
              ),
              Divider(
                indent: 50,
                endIndent: 50,
                thickness: 2,
              ),
              SizedBox(
                height: 20,
              ),
              TextButton(
                  onPressed: () {
                    Get.to(SignInScreen());
                  },
                  child: Text(
                    'Click here if you are  old user.',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  )),
            ],
          ),
        ),
      )),
    );
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late final GlobalKey<FormState> signUpFormKey;
  String email = '';
  String password = '';
  Timer? _timer;
  late double _progress;
  DatabaseReference dbRef =
      FirebaseDatabase.instance.reference().child("Users");

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  signUpWithEmailAndPassword() async {
    try {
      final isValid = signUpFormKey.currentState!.validate();
      if (!isValid) {
        return;
      } else {
        signUpFormKey.currentState!.save();
        EasyLoading.show(status: 'loading...');

        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text)
            .then((result) {
          EasyLoading.showSuccess('Great Success!');

          dbRef.child(result.user!.uid).set({
            "email": emailController.text,
          }).then((value) {
            EasyLoading.dismiss();
            Get.off(CreateBlog());
          });
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        EasyLoading.dismiss();
        Get.snackbar('Error', 'weak-password');
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        EasyLoading.dismiss();
        Get.snackbar('Error', 'The account already exists for that email');
        print('The account already exists for that email.');
      }
    }
  }

  String? validateEmail(String value) {
    if (!GetUtils.isEmail(value)) {
      return 'use correct gmail';
    }
    return null;
  }

  String? validatePassword(String value) {
    if (value.length <= 6) {
      return 'password must be 6 character';
    }
    return null;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    signUpFormKey = GlobalKey<FormState>();
    configLoading();
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
    super.initState();
  }

  void configLoading() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = Colors.yellow
      ..backgroundColor = Colors.green
      ..indicatorColor = Colors.yellow
      ..textColor = Colors.yellow
      ..maskColor = Colors.blue.withOpacity(0.5)
      ..userInteractions = true
      ..dismissOnTap = false;
  }
}
