import 'package:flutter/material.dart';

class PointModel {
  final TextEditingController controller;
  final double? lat, long;

  PointModel({required this.controller, this.lat, this.long});
}
