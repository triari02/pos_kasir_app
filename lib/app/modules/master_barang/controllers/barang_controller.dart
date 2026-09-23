// lib/app/modules/master_barang/controllers/barang_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BarangController extends GetxController {
  // List produk dummy untuk simulasi data awal
  var listBarang = <Map<String, dynamic>>[
    {'id': '1', 'kode': 'BRG001', 'nama': 'Kopi Susu Gula Aren', 'harga_beli': 10000, 'harga_jual': 20000, 'stok': 50},
    {'id': '2', 'kode': 'BRG002', 'nama': 'Roti Bakar Cokelat', 'harga_beli': 15000, 'harga_jual': 35000, 'stok': 30},
  ].obs;

  // Controller untuk Form Input
  final kodeController = TextEditingController();
  final namaController = TextEditingController();
  final beliController = TextEditingController();
  final jualController = TextEditingController();
  final stokController = TextEditingController();

  // Fungsi Tambah Barang
  void tambahBarang() {
    if (namaController.text.isEmpty || jualController.text.isEmpty) {
      Get.snackbar('Error', 'Nama dan Harga Jual wajib diisi', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    listBarang.add({
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'kode': kodeController.text.isEmpty ? 'BRG${listBarang.length + 1}' : kodeController.text,
      'nama': namaController.text,
      'harga_beli': int.tryParse(beliController.text) ?? 0,
      'harga_jual': int.tryParse(jualController.text) ?? 0,
      'stok': int.tryParse(stokController.text) ?? 0,
    });

    bersihkanForm();
    Get.back(); // Tutup dialog/form input
    Get.snackbar('Sukses', 'Barang berhasil ditambahkan', backgroundColor: Colors.green, colorText: Colors.white);
  }

  // Fungsi Edit Barang
  void ubahBarang(String id) {
    int index = listBarang.indexWhere((element) => element['id'] == id);
    if (index != -1) {
      listBarang[index] = {
        'id': id,
        'kode': kodeController.text,
        'nama': namaController.text,
        'harga_beli': int.tryParse(beliController.text) ?? 0,
        'harga_jual': int.tryParse(jualController.text) ?? 0,
        'stok': int.tryParse(stokController.text) ?? 0,
      };
      listBarang.refresh(); // Memaksa UI untuk memperbarui data tampilan
      bersihkanForm();
      Get.back();
      Get.snackbar('Sukses', 'Barang berhasil diubah', backgroundColor: Colors.green, colorText: Colors.white);
    }
  }

  // Fungsi Hapus Barang
  void hapusBarang(String id) {
    listBarang.removeWhere((element) => element['id'] == id);
    Get.snackbar('Sukses', 'Barang telah dihapus', backgroundColor: Colors.orange, colorText: Colors.white);
  }

  // Mengisi form saat tombol edit ditekan
  void siapkanEditForm(Map<String, dynamic> barang) {
    kodeController.text = barang['kode'];
    namaController.text = barang['nama'];
    beliController.text = barang['harga_beli'].toString();
    jualController.text = barang['harga_jual'].toString();
    stokController.text = barang['stok'].toString();
  }

  // Membersihkan isi textfield input
  void bersihkanForm() {
    kodeController.clear();
    namaController.clear();
    beliController.clear();
    jualController.clear();
    stokController.clear();
  }
}
