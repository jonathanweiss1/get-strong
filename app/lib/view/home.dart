import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends GetView {
  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Get Strong!"),
      ),
      body: Center(
        child: const Text("success")
      ),
    );
  }
}