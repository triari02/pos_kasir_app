// lib/app/modules/dashboard/views/dashboard_view.dart
// Taruh di baris paling atas lib/app/modules/dashboard/views/dashboard_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../login/views/login_view.dart';
import '../../master_barang/views/barang_view.dart';
import '../../penjualan/views/penjualan_view.dart';
import '../../pembelian/views/pembelian_view.dart';
import '../../laporan/views/laporan_view.dart';



class DashboardView extends StatelessWidget {
  // List menu aplikasi sesuai permintaan kebutuhan fitur POS
  final List<Map<String, dynamic>> menus = [
    {'title': 'Penjualan (Kasir)', 'icon': Icons.shopping_cart, 'color': Colors.green, 'route': () => Get.to(() => PenjualanView())},
    {'title': 'Pembelian (Stok Masuk)', 'icon': Icons.add_business, 'color': Colors.orange, 'route': () => Get.to(() => PembelianView())},
    {'title': 'Master Barang', 'icon': Icons.inventory, 'color': Colors.blue, 'route': () => Get.to(() => BarangView())},
    {'title': 'Laporan Penjualan', 'icon': Icons.bar_chart, 'color': Colors.purple, 'route': () => Get.to(() => LaporanView())},
    {'title': 'Laporan Stok', 'icon': Icons.assignment, 'color': Colors.teal, 'route': () => Get.to(() => LaporanView())},

  ];

  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard POS', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueGrey[900],
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              // Dialog konfirmasi Log Out
              Get.defaultDialog(
                title: 'Keluar Aplikasi',
                middleText: 'Apakah Anda yakin ingin log out?',
                textConfirm: 'Ya',
                textCancel: 'Batal',
                confirmTextColor: Colors.white,
                buttonColor: Colors.red,
                onConfirm: () => Get.offAll(() => LoginView()),
              );
            },
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Informasi Ringkas Pengguna
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.blueGrey[900],
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Halo, Admin Toko', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('Akses Menu Utama POS Anda di bawah ini:', style: TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),
          
          // Grid Menu Aplikasi
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 kolom grid
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1, // Rasio dimensi kotak menu
                ),
                itemCount: menus.length,
                itemBuilder: (context, index) {
                  final menu = menus[index];
                  return InkWell(
                    onTap: menu['route'],
                    borderRadius: BorderRadius.circular(16),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: menu['color'].withOpacity(0.1),
                            child: Icon(menu['icon'], size: 32, color: menu['color']),
                          ),
                          SizedBox(height: 12),
                          Text(
                            menu['title'],
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.blueGrey[800]),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
