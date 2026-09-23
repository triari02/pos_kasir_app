// lib/app/modules/login/controllers/login_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../dashboard/views/dashboard_view.dart';


class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  
  var isLoading = false.obs;
  var isPasswordHidden = true.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void login() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      
      // Simulasi proses autentikasi jaringan/lokal selama 2 detik
      await Future.delayed(Duration(seconds: 2));
      
      isLoading.value = false;

      // Contoh validasi sederhana
      if (usernameController.text == 'admin' && passwordController.text == 'admin123') {
        Get.offAll(() => DashboardView()); // Pindah ke dashboard dan hapus histori back
        Get.snackbar(
          'Sukses', 'Selamat datang kembali, Admin!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Gagal Login', 'Username atau password salah.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
