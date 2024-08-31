import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'binding_controller.dart';
import 'home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
      initialBinding: BindingController(),
    );
  }
}