// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Update extends StatefulWidget {
  const Update({
    Key? key,
  }) : super(key: key);

  @override
  _UpdateState createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  var blogId = Get.arguments;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  var name = "";
  var email = "";
  final titleController = TextEditingController();
  final desController = TextEditingController();

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
        title: Text('Edit Blog'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future:
                FirebaseFirestore.instance.collection('blog').doc(blogId).get(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data;
                var title = snapshot.data!['title'];
                var des = snapshot.data!['des'];
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 300,
                      ),
                      TextFormField(
                        onChanged: (value) => title = value,
                        initialValue: title,
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
                        onChanged: (value) => des = value,
                        initialValue: des,
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
                          updateUser(blogId, title, des);
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
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
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
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Text('dnd');
            }),
        // child: Padding(
        //   padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        //   child: ListView(
        //     children: [
        //       SizedBox(
        //         height: 300,
        //       ),
        //       TextFormField(
        //         controller: titleController,
        //         textAlign: TextAlign.center,
        //         validator: (value) {
        //           if (value == null || value.isEmpty) {
        //             return 'Please Enter Title';
        //           }
        //           return null;
        //         },
        //         keyboardType: TextInputType.multiline,
        //         maxLines: null,
        //         minLines: 1,
        //         decoration: InputDecoration(
        //           filled: true,
        //           hintText: "Title  ",
        //           border: OutlineInputBorder(),
        //         ),
        //       ),
        //       SizedBox(
        //         height: 20,
        //       ),
        //       TextFormField(
        //         controller: desController,
        //         validator: (value) {
        //           if (value == null || value.isEmpty) {
        //             return 'Please Enter description';
        //           }
        //           // if (value == null || value.isEmpty) {
        //           //   return 'Please Enter Email';
        //           // } else if (!value.contains('@')) {
        //           //   return 'Please Enter Valid Email';
        //           // }
        //           return null;
        //         },
        //         keyboardType: TextInputType.multiline,
        //         maxLines: null,
        //         minLines: 1,
        //         textAlign: TextAlign.center,
        //         decoration: InputDecoration(
        //           filled: true,
        //           hintText: "Description  ",
        //           border: OutlineInputBorder(),
        //         ),
        //       ),
        //       SizedBox(
        //         height: 20,
        //       ),
        //       Text(blogId.toString()),
        //       ElevatedButton(
        //         onPressed: () {
        //           print(blogId);
        //           // Validate returns true if the form is valid, otherwise false.
        //           // if (_formKey.currentState!.validate()) {
        //           //   setState(() {
        //           //     print
        //           //     name = titleController.text;
        //           //     email = desController.text;
        //           //     addBlog();
        //           //     clearText();
        //           //   });
        //           // }
        //         },
        //         child: Text(
        //           'Upload Blog',
        //           style: TextStyle(fontSize: 18.0),
        //         ),
        //       ),
        //       SizedBox(
        //         height: 20,
        //       ),
        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           Text(
        //             'Clear  your Title and Description',
        //             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        //           ),
        //           SizedBox(
        //             width: 20,
        //           ),
        //           Container(
        //             decoration: BoxDecoration(
        //               color: Colors.red,
        //               borderRadius: BorderRadius.circular(50),
        //               // border: Border.all(color: Colors.blueAccent)
        //             ),
        //             child: IconButton(
        //                 onPressed: () {
        //                   clearText();
        //                 },
        //                 icon: Icon(Icons.cleaning_services)),
        //           )
        //         ],
        //       ),
        //     ],
        //   ),
        // ),
      ),
    );
  }

  Future<void> updateUser(id, title, des) {
    return blog
        .doc(id)
        .update({'title': title, 'des': des})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    titleController.dispose();
    desController.dispose();

    super.dispose();
  }
}
