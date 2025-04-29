import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.title,
          style: const TextStyle(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: const Center(
          child: Text(
            "School Routes",
            style: TextStyle(fontSize: 20),
          ),
      ),
    );
  }
}
