import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/createblog_controller.dart';

class CreateblogView extends GetView<CreateblogController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CreateblogView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'CreateblogView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
