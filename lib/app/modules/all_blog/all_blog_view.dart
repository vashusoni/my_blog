// // ignore_for_file: prefer_const_constructors
//
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
//
// import 'package:get/get.dart';
//
// import '../controllers/createblog_controller.dart';
//
// class CreateBlogView extends GetView<CreateblogController> {
//   const CreateBlogView({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Create New Blog'),
//         centerTitle: true,
//       ),
//       body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Container(
//
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(5),
//                   border: Border.all(color: Colors.grey)
//               ),
//               height: 55,
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child:
//               TextFormField(
//                 keyboardType: TextInputType.multiline,
//                 maxLines: null,
//                 textAlign: TextAlign.center,
//
//                 decoration: InputDecoration(
//                   hintStyle: TextStyle(fontSize: 17),
//                   hintText: 'Type Title Here',
//
//                   border: InputBorder.none,
//                   contentPadding: EdgeInsets.all(18),
//                 ),
//                 onSaved: (value) {
//                   // controller.mobile = value!;
//                 },
//                 // validator: (value) {
//                 //   return controller.validateMobile(value!);
//                 // },
//                 // controller: controller.mobileController,
//
//               ),
//             ),
//           ),          Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Container(
//
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(5),
//
//                   border: Border.all(color: Colors.grey)
//               ),
//               height: 200,
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child:
//               TextFormField(
//                 keyboardType: TextInputType.multiline,
//                 maxLines: null,
//                 textAlign: TextAlign.center,
//
//                 decoration: InputDecoration(
//                     hintStyle: TextStyle(fontSize: 17),
//                     hintText: 'Type description here',
//
//                     border: InputBorder.none,
//                     contentPadding: EdgeInsets.all(18),
//                   ),
//                 onSaved: (value) {
//                   // controller.mobile = value!;
//                 },
//                 // validator: (value) {
//                 //   return controller.validateMobile(value!);
//                 // },
//                 // controller: controller.mobileController,
//
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 30,
//           ),
//           ElevatedButton(
//             child: Text('Login'),
//             onPressed: () {},
//             style: ElevatedButton.styleFrom(
//                 primary: Colors.black.withOpacity(.2),
//                 padding: EdgeInsets.symmetric(horizontal: 80, vertical: 13),
//                 textStyle:
//                     TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
//           ),
//           SizedBox(
//             height: 30,
//           ),
//         ],
//       )),
//     );
//   }
// }
// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_blog/app/modules/create_board/create_new_blog.dart';
import 'package:my_blog/app/modules/update/update.dart';
import 'package:my_blog/app/repo/services.dart';

import '../../model/weather_model.dart';

class AllBlogs extends StatefulWidget {
  @override
  State<AllBlogs> createState() => _AllBlogsState();
}

class _AllBlogsState extends State<AllBlogs> {
  var response = Get.arguments;
  final Stream<QuerySnapshot> blogStream =
      FirebaseFirestore.instance.collection('blog').snapshots();

  CollectionReference blogCollection =
      FirebaseFirestore.instance.collection('blog');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(response.cityName.toString()),
                SizedBox(
                  width: 2,
                ),
                Icon(
                  FontAwesomeIcons.cloudSun,
                  size: 15,
                ),
                SizedBox(
                    height: 40,
                    width: 40,
                    child: Image.network(response.iconUrl)),
                Text(
                  '${response.tempInfo?.temperature}°',
                  style: TextStyle(fontSize: 20),
                ),
                Text(response.weatherInfo!.description.toString()),
              ],
            ),
          ),

          TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              child: Text('LouOut',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),))
          // IconButton(onPressed: () async {
          // await FirebaseAuth.instance.signOut();
          // },icon: Icon(Icons.logout_rounded))
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: blogStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              var blogID = document.id;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                Get.to(Update(), arguments: blogID);
                              },
                              child: Icon(
                                Icons.edit,
                                color: Colors.blueAccent,
                                size: 20,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                deleteUser(blogID);
                              },
                              child: Icon(
                                Icons.delete_forever,
                                color: Colors.red,
                                size: 20,
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          data['title'].toString(),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Divider(
                        endIndent: 100,
                        indent: 100,
                        thickness: 2,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          data['des'].toString(),
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: ElevatedButton(
      //     style: ButtonStyle(
      //       backgroundColor: MaterialStateProperty.all(Colors.red),
      //     ),
      //
      //     child: Text(
      //       'LogOut',
      //       style: TextStyle(fontSize: 18.0),
      //     ),
      //   ),
      // ),
      floatingActionButton: FloatingActionButton(
        elevation: 9,
        child: Icon(Icons.add_comment_sharp),
        onPressed: () {
          Get.to(CreateBlog());
        },
      ),
    );
  }

  Future<void> deleteUser(String docID) {
    return blogCollection
        .doc(docID)
        .delete()
        .then((value) => print("User Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }
}
