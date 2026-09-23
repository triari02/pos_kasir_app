// lib/app/modules/laporan/controllers/laporan_controller.dart
import 'package:get/get.dart';
import '../../master_barang/controllers/barang_controller.dart';

class LaporanController extends GetxController {
  // Hubungkan ke BarangController untuk membaca real-time stok master barang
  final BarangController barangController = Get.find<BarangController>();

  // Dummy Data Riwayat Penjualan untuk Laporan & Grafik
  var riwayatPenjualan = <Map<String, dynamic>>[
    {'tanggal': '19 Sep', 'total': 150000, 'item_terjual': 8},
    {'tanggal': '20 Sep', 'total': 280000, 'item_terjual': 12},
    {'tanggal': '21 Sep', 'total': 420000, 'item_terjual': 19},
    {'tanggal': '22 Sep', 'total': 310000, 'item_terjual': 15},
    {'tanggal': '23 Sep', 'total': 550000, 'item_terjual': 22}, // Hari Ini
  ].obs;

  // Menghitung akumulasi total omset penjualan
  int get totalOmset => riwayatPenjualan.fold(0, (sum, item) => sum + (item['total'] as int));

  // Menghitung akumulasi total barang yang berhasil keluar/terjual
  int get totalItemTerjual => riwayatPenjualan.fold(0, (sum, item) => sum + (item['item_terjual'] as int));
}
