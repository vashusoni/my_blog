// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';
import 'package:my_blog/app/modules/create_blog/all_blog_view.dart';
import 'package:my_blog/app/modules/dash_board/create_new_blog.dart';
import 'package:my_blog/app/modules/sign_up/sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late final GlobalKey<FormState> signInFormKey;
  String email = '';
  String password = '';
  Timer? _timer;
  DatabaseReference dbRef =
      FirebaseDatabase.instance.reference().child("Users");

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Form(
        key: signInFormKey,
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
                'SignIn Here',
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
                child: Text('SignIn'),
                onPressed: () {
                  signInWithEmailAndPassword();
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
                  onPressed: () async {
                    await Future.delayed(
                      Duration(milliseconds: 600),
                    );
                    Get.offAll(SignUpScreen());
                  },
                  child: Text(
                    'Click here if you are a new user.',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  )),
            ],
          ),
        ),
      )),
    );
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
    signInFormKey = GlobalKey<FormState>();

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

  signInWithEmailAndPassword() async {
    try {
      final isValid = signInFormKey.currentState!.validate();
      if (!isValid) {
        return;
      } else {
        signInFormKey.currentState!.save();
        EasyLoading.show(status: 'loading...');

        await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailController.text, password: passwordController.text)
            .then((result) {
          EasyLoading.showSuccess('Great Success!');
          EasyLoading.dismiss();
          Get.offAll(AllBlogs());
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        EasyLoading.dismiss();

        Get.snackbar('Error', 'User Not found');
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        EasyLoading.dismiss();
        Get.snackbar('Error', 'Wrong password provided for that user');
        print('Wrong password provided for that user.');
      }
    }
  }
}
