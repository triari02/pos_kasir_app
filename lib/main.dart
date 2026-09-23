// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/modules/login/views/login_view.dart';
import 'app/modules/master_barang/controllers/barang_controller.dart'; // Import ini

void main() {
  // Masukkan controller barang ke memory global sebelum app jalan
  Get.put(BarangController()); 
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter POS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: LoginView(),
    );
  }
}
