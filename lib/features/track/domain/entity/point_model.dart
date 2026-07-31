import 'package:flutter/material.dart';

class PointModel {
  final TextEditingController controller;
  double? lat, long;

  PointModel({required this.controller, this.lat, this.long});
}
