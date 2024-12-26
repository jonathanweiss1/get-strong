import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_strong/components/fact_panel.dart';
import 'package:get_strong/config.dart';
import 'package:get_strong/controller/analytics.dart';

/// Analytics page
class AnalyticsView extends GetView<AnalyticsController> {
  final analyticsCtrl = Get.find<AnalyticsController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FactPanel(
                label: "Highest 1RM",
                value: analyticsCtrl.highest1RM.value.toStringAsFixed(2),
                colorGradient: GSSecondaryGradient,
              ),
              FactPanel(
                label: "Most Reps",
                value: analyticsCtrl.mostReps.value.toString(),
                colorGradient: GSHighlightGradient,
              ),
              FactPanel(
                label: "Highest Weight",
                value: analyticsCtrl.highestWeight.value.toStringAsFixed(2),
                colorGradient: GSPrimaryGradient,
              )
            ]));
  }
}
