// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'
    '';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CreateBlog extends StatefulWidget {
  const CreateBlog({Key? key}) : super(key: key);

  @override
  _CreateBlogState createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  var name = "";
  var email = "";
  final titleController = TextEditingController();
  final desController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    titleController.dispose();
    desController.dispose();

    super.dispose();
  }

  clearText() {
    titleController.clear();
    desController.clear();
  }

  // Adding Student
  CollectionReference blog = FirebaseFirestore.instance.collection('blog');

  Future<void> addBlog() {
    return blog
        .add({
          'title': name,
          'des': email,
        })
        .then((value) => print('blog Added'))
        .catchError((error) => print('Failed to Add blog: $error'));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Create new blog'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: ListView(
            children: [
              SizedBox(
                height: 300,
              ),
              TextFormField(
                controller: titleController,
                textAlign: TextAlign.center,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter Title';
                  }
                  return null;
                },
                keyboardType: TextInputType.multiline,
                maxLines: null,
                minLines: 1,
                decoration: InputDecoration(
                  filled: true,
                  hintText: "Title  ",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: desController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter description';
                  }
                  // if (value == null || value.isEmpty) {
                  //   return 'Please Enter Email';
                  // } else if (!value.contains('@')) {
                  //   return 'Please Enter Valid Email';
                  // }
                  return null;
                },
                keyboardType: TextInputType.multiline,
                maxLines: null,
                minLines: 1,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  filled: true,
                  hintText: "Description  ",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, otherwise false.
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      name = titleController.text;
                      email = desController.text;
                      addBlog();
                      clearText();
                    });
                  }
                },
                child: Text(
                  'Upload Blog',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Clear  your Title and Description',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(50),
                      // border: Border.all(color: Colors.blueAccent)
                    ),
                    child: IconButton(
                        onPressed: () {
                          clearText();
                        },
                        icon: Icon(Icons.cleaning_services)),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
