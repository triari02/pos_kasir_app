// lib/app/modules/laporan/views/laporan_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/laporan_controller.dart';

class LaporanView extends StatelessWidget {
  final controller = Get.put(LaporanController());

  const LaporanView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // 2 Halaman Tab
      child: Scaffold(
        appBar: AppBar(
          title: Text('Laporan POS', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.blueGrey,
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.bar_chart), text: 'Laporan Penjualan'),
              Tab(icon: Icon(Icons.inventory_2), text: 'Laporan Stok'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildLaporanPenjualan(),
            _buildLaporanStok(),
          ],
        ),
      ),
    );
  }

  // ================= TAB 1: LAPORAN PENJUALAN =================
  Widget _buildLaporanPenjualan() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ringkasan Total Pendapatan Box
          Card(
            color: Colors.blueGrey.shade800,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Omset Penjualan', style: TextStyle(color: Colors.white70)),
                      SizedBox(height: 8),
                      Obx(() => Text('Rp ${controller.totalOmset}', 
                          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold))),
                    ],
                  ),
                  Icon(Icons.monetization_on, color: Colors.greenAccent, size: 40),
                ],
              ),
            ),
          ),
          SizedBox(height: 24),
          
          Text('Grafik Omset 5 Hari Terakhir', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 16),
          
          // Grafik Penjualan (fl_chart)
          Container(
            height: 200,
            padding: EdgeInsets.only(right: 16, top: 16),
            child: Obx(() => BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 600000,
                barGroups: controller.riwayatPenjualan.asMap().entries.map((entry) {
                  int index = entry.key;
                  var data = entry.value;
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: (data['total'] as int).toDouble(),
                        color: Colors.blue,
                        width: 16,
                        borderRadius: BorderRadius.circular(4),
                      )
                    ],
                  );
                }).toList(),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index >= 0 && index < controller.riwayatPenjualan.length) {
                          return Text(controller.riwayatPenjualan[index]['tanggal'], style: TextStyle(fontSize: 10));
                        }
                        return Text('');
                      },
                    ),
                  ),
                ),
              ),
            )),
          ),
          SizedBox(height: 24),

          Text('Tabel Rincian Harian', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 8),
          
          // Tabel Riwayat
          Obx(() => ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: controller.riwayatPenjualan.length,
            itemBuilder: (context, index) {
              final item = controller.riwayatPenjualan[index];
              return ListTile(
                leading: Icon(Icons.check_circle, color: Colors.green),
                title: Text('Tanggal ${item['tanggal']}'),
                subtitle: Text('${item['item_terjual']} Produk Terjual'),
                trailing: Text('Rp ${item['total']}', style: TextStyle(fontWeight: FontWeight.bold)),
              );
            },
          )),
        ],
      ),
    );
  }

  // ================= TAB 2: LAPORAN STOK INVENTARIS =================
  Widget _buildLaporanStok() {
    return Obx(() {
      final listBarang = controller.barangController.listBarang;
      if (listBarang.isEmpty) {
        return Center(child: Text('Tidak ada data produk di Master Barang.'));
      }
      return ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: listBarang.length,
        itemBuilder: (context, index) {
          final barang = listBarang[index];
          final bool stokMenipis = barang['stok'] <= 5; // Indikator stok kritis kurang dari sama dengan 5

          return Card(
            elevation: 2,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: stokMenipis ? Colors.red.withOpacity(0.1) : Colors.teal.withOpacity(0.1),
                child: Icon(
                  stokMenipis ? Icons.warning : Icons.inventory,
                  color: stokMenipis ? Colors.red : Colors.teal
                ),
              ),
              title: Text(barang['nama'], style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Kode: ${barang['kode']} \nHarga Beli: Rp ${barang['harga_beli']} | Jual: Rp ${barang['harga_jual']}'),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${barang['stok']}', 
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: stokMenipis ? Colors.red : Colors.black)),
                  Text(
                    stokMenipis ? 'Stok Kritis!' : 'Aman',
                    style: TextStyle(fontSize: 10, color: stokMenipis ? Colors.red : Colors.grey, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
