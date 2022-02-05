import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_blog/app/modules/create_blog/all_blog_view.dart';
import 'package:my_blog/app/modules/dash_board/create_new_blog.dart';
import 'package:my_blog/app/modules/sign_in/sign_in_screen.dart';

// ignore_for_file: prefer_const_constructors
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    getUser();
    super.initState();
  }

  void getUser(){
    Timer(Duration(seconds: 3), () {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          Get.offAll(SignInScreen());
        } else {
          Get.offAll(AllBlogs());
        }
      });
      // Get.offAllNamed('/sign_in');
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              width: 250, child: Image.asset('assets/images/blog_icon.png')),
          Text('MY WORD',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black.withOpacity(.45),
                  letterSpacing: 7)),
          Divider(
            endIndent: 100,
            thickness: 1,
            indent: 100,
          )
        ],
      )),
    );
  }
}
