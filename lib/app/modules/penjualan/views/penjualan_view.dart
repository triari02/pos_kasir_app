// lib/app/modules/penjualan/views/penjualan_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/penjualan_controller.dart';

class PenjualanView extends StatelessWidget {
  final controller = Get.put(PenjualanController());

  const PenjualanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kasir Penjualan', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          // 1. AREA PILIH BARANG DARI MASTER BARANG
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Pilih Produk (Ketuk untuk tambah):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
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
                        subtitle: Text('Stok: ${produk['stok']} | Rp ${produk['harga_jual']}'),
                        trailing: Icon(Icons.add_circle, color: Colors.green),
                        onTap: () => controller.tambahKeKeranjang(produk),
                      );
                    },
                  )),
          ),
          Divider(thickness: 2),

          // 2. AREA KERANJANG BELANJA
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Keranjang Belanja:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.blueGrey)),
            ),
          ),
          Expanded(
            flex: 5,
            child: Obx(() => controller.keranjang.isEmpty
                ? Center(child: Text('Keranjang masih kosong.'))
                : ListView.builder(
                    itemCount: controller.keranjang.length,
                    itemBuilder: (context, index) {
                      final item = controller.keranjang[index];
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        child: ListTile(
                          title: Text(item['nama']),
                          subtitle: Text('Rp ${item['harga_jual']} x ${item['qty']}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove_circle_outline, color: Colors.red),
                                onPressed: () => controller.kurangiDariKeranjang(item),
                              ),
                              Text('${item['qty']}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              IconButton(
                                icon: Icon(Icons.add_circle_outline, color: Colors.green),
                                onPressed: () => controller.tambahKeKeranjang(item),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )),
          ),

          // 3. RINGKASAN TOTAL DAN TOMBOL BAYAR
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2))]
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Bayar:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Obx(() => Text(
                            'Rp ${controller.totalBayar}',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                          )),
                    ],
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                      ),
                      icon: Icon(Icons.print_rounded, color: Colors.white),
                      label: Text('BAYAR & CETAK STRUK', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        if(controller.keranjang.isNotEmpty) {
                          controller.prosesPembayaran();
                        } else {
                          Get.snackbar('Keranjang Kosong', 'Pilih item dahulu sebelum bayar.', backgroundColor: Colors.orange, colorText: Colors.white);
                        }
                      },
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
