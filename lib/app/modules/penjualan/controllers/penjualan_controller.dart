// lib/app/modules/penjualan/controllers/penjualan_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../master_barang/controllers/barang_controller.dart';
import '../../cetak_struk/preview_struk.dart';

class PenjualanController extends GetxController {
  // Mengambil instance dari BarangController untuk mengakses daftar produk
  final BarangController barangController = Get.find<BarangController>();

  // RxList untuk menampung item yang dimasukkan ke keranjang belanja
  var keranjang = <Map<String, dynamic>>[].obs;

  // Menghitung total harga belanja secara otomatis (computed property)
  int get totalBayar => keranjang.fold(0, (sum, item) => sum + (item['harga_jual'] * item['qty'] as int));

  // Fungsi menambah barang ke keranjang
  void tambahKeKeranjang(Map<String, dynamic> barang) {
    // Cek apakah stok barang mencukupi
    if (barang['stok'] <= 0) {
      Get.snackbar('Stok Habis', 'Barang ${barang['nama']} sudah tidak tersedia.', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    // Cek apakah barang sudah ada di keranjang
    int index = keranjang.indexWhere((element) => element['id'] == barang['id']);

    if (index != -1) {
      // Jika sudah ada, cek apakah penambahan qty melebihi stok yang ada
      if (keranjang[index]['qty'] >= barang['stok']) {
        Get.snackbar('Stok Batas', 'Tidak bisa menambah lagi, stok terbatas.', backgroundColor: Colors.orange, colorText: Colors.white);
        return;
      }
      keranjang[index]['qty']++;
      keranjang.refresh();
    } else {
      // Jika belum ada, masukkan sebagai item baru dengan qty = 1
      keranjang.add({
        'id': barang['id'],
        'kode': barang['kode'],
        'nama': barang['nama'],
        'harga_jual': barang['harga_jual'],
        'qty': 1,
      });
    }
  }

  // Fungsi mengurangi jumlah kuantitas di keranjang
  void kurangiDariKeranjang(Map<String, dynamic> item) {
    int index = keranjang.indexWhere((element) => element['id'] == item['id']);
    if (index != -1) {
      if (keranjang[index]['qty'] > 1) {
        keranjang[index]['qty']--;
        keranjang.refresh();
      } else {
        keranjang.removeAt(index);
      }
    }
  }

  // Fungsi simulasi checkout pembayaran dan potong stok asli
  void prosesPembayaran() {
    if (keranjang.isEmpty) {
      Get.snackbar('Keranjang Kosong', 'Silakan pilih barang terlebih dahulu', backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    // 1. Potong stok asli yang ada di Master Barang
    for (var itemKeranjang in keranjang) {
      int indexBrg = barangController.listBarang.indexWhere((b) => b['id'] == itemKeranjang['id']);
      if (indexBrg != -1) {
        var barangAsli = barangController.listBarang[indexBrg];
        barangController.listBarang[indexBrg] = {
          ...barangAsli,
          'stok': barangAsli['stok'] - itemKeranjang['qty'],
        };
      }
    }
    barangController.listBarang.refresh();

    // 2. Siapkan format data untuk dilempar ke service cetak struk
    final formatTransaksi = {
      'invoice': 'INV-${DateTime.now().year}${DateTime.now().month.toString().padLeft(2,'0')}${DateTime.now().day.toString().padLeft(2,'0')}-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
      'tanggal': '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year} ${DateTime.now().hour}:${DateTime.now().minute}',
      'total': 'Rp $totalBayar',
      'items': keranjang.map((element) => {
        'nama': element['nama'],
        'qty': element['qty'],
        'subtotal': 'Rp ${element['harga_jual'] * element['qty']}',
      }).toList(),
    };

    // 3. Bersihkan keranjang belanja
    keranjang.clear();

    // 4. Langsung tampilkan preview cetak struk menggunakan cetak_struk/receipt_service.dart
    Get.back(); // Tutup dialog kasir jika ada
    ReceiptService.showPreview(formatTransaksi);
    
    Get.snackbar('Sukses', 'Transaksi Berhasil Disimpan!', backgroundColor: Colors.green, colorText: Colors.white);
  }
}
