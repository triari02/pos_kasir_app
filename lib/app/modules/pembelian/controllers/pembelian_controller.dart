// lib/app/modules/pembelian/controllers/pembelian_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../master_barang/controllers/barang_controller.dart';

class PembelianController extends GetxController {
  // Mengambil instance dari BarangController untuk memperbarui stok barang
  final BarangController barangController = Get.find<BarangController>();

  // List untuk menampung barang yang akan di-restock
  var keranjangPembelian = <Map<String, dynamic>>[].obs;

  // Menghitung total biaya pembelian secara otomatis
  int get totalPembelian => keranjangPembelian.fold(0, (sum, item) => sum + (item['harga_beli'] * item['qty'] as int));

  // Fungsi menambah barang ke daftar restock
  void tambahKePembelian(Map<String, dynamic> barang) {
    int index = keranjangPembelian.indexWhere((element) => element['id'] == barang['id']);

    if (index != -1) {
      keranjangPembelian[index]['qty']++;
      keranjangPembelian.refresh();
    } else {
      keranjangPembelian.add({
        'id': barang['id'],
        'kode': barang['kode'],
        'nama': barang['nama'],
        'harga_beli': barang['harga_beli'],
        'qty': 1,
      });
    }
  }

  // Fungsi mengurangi jumlah kuantitas restock di keranjang
  void kurangiDariPembelian(Map<String, dynamic> item) {
    int index = keranjangPembelian.indexWhere((element) => element['id'] == item['id']);
    if (index != -1) {
      if (keranjangPembelian[index]['qty'] > 1) {
        keranjangPembelian[index]['qty']--;
        keranjangPembelian.refresh();
      } else {
        keranjangPembelian.removeAt(index);
      }
    }
  }

  // Fungsi menyimpan transaksi pembelian dan menambah stok di Master Barang
  void simpanPembelian() {
    if (keranjangPembelian.isEmpty) {
      Get.snackbar('Gagal', 'Daftar pembelian masih kosong', backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    // Lakukan perulangan untuk menambah stok asli di Master Barang
    for (var itemMasuk in keranjangPembelian) {
      int indexBrg = barangController.listBarang.indexWhere((b) => b['id'] == itemMasuk['id']);
      if (indexBrg != -1) {
        var barangAsli = barangController.listBarang[indexBrg];
        barangController.listBarang[indexBrg] = {
          ...barangAsli,
          'stok': barangAsli['stok'] + itemMasuk['qty'], // Tambah stok
        };
      }
    }
    barangController.listBarang.refresh();
    keranjangPembelian.clear(); // Bersihkan keranjang

    Get.back();
    Get.snackbar('Sukses', 'Stok berhasil ditambahkan ke Master Barang!', backgroundColor: Colors.green, colorText: Colors.white);
  }
}
