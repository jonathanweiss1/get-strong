import 'package:app/view/train.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/home.dart';
import '../main.dart';
import '../services/authentication.dart';
import 'analytics.dart';

class HomeView extends GetView<HomeController> {
  final HomeController homeCtrl = Get.find();
  final AuthService authService = Get.find<AuthService>();
  
  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Get Strong!"),
        actions: [IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            await authService.signOutUser();
            Get.off(LoginView());
          },
        )
        ],
      ),
      bottomNavigationBar: Container(
        color: Theme.of(context).appBarTheme.backgroundColor,
        child: TabBar(
          controller: homeCtrl.tabController,
          tabs: const [
            Tab(icon: Icon(Icons.fitness_center)),
            Tab(icon: Icon(Icons.analytics))
          ],
          )
        ),
      body: TabBarView(
        controller: homeCtrl.tabController,
        children: [
          TrainView(),
          AnalyticsView()
        ]),
    );
  }
}