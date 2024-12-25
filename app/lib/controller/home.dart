import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Controller for home view. Essentially only initializes a tab controller.
class HomeController extends GetxController with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void onInit() {
    tabController = TabController(vsync: this, length: 2);
    super.onInit();
  }
}