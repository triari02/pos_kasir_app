// lib/app/modules/pembelian/views/pembelian_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pembelian_controller.dart';

class PembelianView extends StatelessWidget {
  final controller = Get.put(PembelianController());

  const PembelianView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pembelian (Stok Masuk)', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Pengaturan posisi teks dipindah ke sini
        children: [
          // 1. DAFTAR BARANG YANG BISA DI-RESTOCK
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              'Pilih Barang Supplier (Ketuk untuk menambah kuantitas):', 
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 4,
            child: Obx(() => controller.barangController.listBarang.isEmpty
                ? Center(child: Text('Belum ada produk di Master Barang.'))
                : ListView.builder(
                    itemCount: controller.barangController.listBarang.length,
                    itemBuilder: (context, index) {
                      final produk = controller.barangController.listBarang[index];
                      return ListTile(
                        title: Text(produk['nama']),
                        subtitle: Text('Stok Saat Ini: ${produk['stok']} | H. Beli: Rp ${produk['harga_beli']}'),
                        trailing: Icon(Icons.add_box, color: Colors.orange),
                        onTap: () => controller.tambahKePembelian(produk),
                      );
                    },
                  )),
          ),
          Divider(thickness: 2),

          // 2. DAFTAR KERANJANG BARANG MASUK
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              'Rencana Barang Masuk:', 
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
            ),
          ),
          Expanded(
            flex: 5,
            child: Obx(() => controller.keranjangPembelian.isEmpty
                ? Center(child: Text('Belum ada barang masuk yang dipilih.'))
                : ListView.builder(
                    itemCount: controller.keranjangPembelian.length,
                    itemBuilder: (context, index) {
                      final item = controller.keranjangPembelian[index];
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        child: ListTile(
                          title: Text(item['nama']),
                          subtitle: Text('Biaya: Rp ${item['harga_beli']} x ${item['qty']}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.indeterminate_check_box, color: Colors.red),
                                onPressed: () => controller.kurangiDariPembelian(item),
                              ),
                              Text('${item['qty']}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              IconButton(
                                icon: Icon(Icons.add_box, color: Colors.green),
                                onPressed: () => controller.tambahKePembelian(item),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )),
          ),

          // 3. TOMBOL SIMPAN DATA STOK MASUK
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2))]),
            child: SafeArea(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Pengeluaran:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Obx(() => Text(
                            'Rp ${controller.totalPembelian}',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange),
                          )),
                    ],
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: EdgeInsets.symmetric(vertical: 14),
                      ),
                      icon: Icon(Icons.save, color: Colors.white),
                      label: Text('SIMPAN & UPDATE STOK', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      onPressed: () => controller.simpanPembelian(),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
