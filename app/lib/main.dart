import 'package:get_strong/controller/analytics.dart';
import 'package:get_strong/controller/train.dart';
import 'package:get_strong/services/database.dart';
import 'package:get_strong/view/login.dart';

import 'controller/home.dart';
import 'services/authentication.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/login.dart';
import 'firebase_options.dart';
import 'services/workoutplan_loader.dart';
import 'config.dart';

void main() async {

  // init
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(DatabaseService());
  Get.put(AuthService());
  Get.put(WorkoutPlanLoaderService());
  Get.put(LoginController());
  Get.put(HomeController());
  Get.put(TrainController());
  Get.put(AnalyticsController());

  // main frame
  runApp(GetMaterialApp(
    home: LoginView(), 
    theme: ThemeData.light().copyWith(
      primaryColor: GSPrimaryColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFFFFFFF),
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: GSTextColor,
        ),
        actionsIconTheme: IconThemeData(color: GSTextColor)
      ),
      tabBarTheme: const TabBarTheme(
        indicator: BoxDecoration(border: Border(bottom: BorderSide(color: GSHighlightColor))),
        unselectedLabelColor: GSTextColor,
        labelColor: GSHighlightColor
        ),
    ),
    title: 'Get Strong!',
    debugShowCheckedModeBanner: false,
    ));
}