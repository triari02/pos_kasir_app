// lib/app/modules/master_barang/views/barang_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/barang_controller.dart';

class BarangView extends StatelessWidget {
  // Di dalam barang_view.dart
final controller = Get.find<BarangController>();

  const BarangView({super.key}); // Ubah put menjadi find


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Master Barang', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueGrey,
      ),
      body: Obx(() => controller.listBarang.isEmpty
          ? Center(child: Text('Belum ada data barang.'))
          : ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: controller.listBarang.length,
              itemBuilder: (context, index) {
                final barang = controller.listBarang[index];
                return Card(
                  elevation: 2,
                  margin: EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.withOpacity(0.1),
                      child: Icon(Icons.inventory_2, color: Colors.blue),
                    ),
                    title: Text(barang['nama'], style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Kode: ${barang['kode']} | Stok: ${barang['stok']}\nJual: Rp ${barang['harga_jual']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Tombol Edit
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.orange),
                          onPressed: () {
                            controller.siapkanEditForm(barang);
                            tampilkanFormModal(context, isEdit: true, id: barang['id']);
                          },
                        ),
                        // Tombol Hapus
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            Get.defaultDialog(
                              title: 'Hapus Barang',
                              middleText: 'Yakin ingin menghapus ${barang['nama']}?',
                              textConfirm: 'Hapus',
                              textCancel: 'Batal',
                              confirmTextColor: Colors.white,
                              buttonColor: Colors.red,
                              onConfirm: () {
                                controller.hapusBarang(barang['id']);
                                Get.back();
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          controller.bersihkanForm();
          tampilkanFormModal(context, isEdit: false);
        },
      ),
    );
  }

  // Modal Pop-up Form untuk Tambah & Edit
  void tampilkanFormModal(BuildContext context, {required bool isEdit, String? id}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom, // Agar input tidak tertutup keyboard
          top: 20, left: 20, right: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                isEdit ? 'Ubah Detail Barang' : 'Tambah Barang Baru',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              TextField(controller: controller.kodeController, decoration: InputDecoration(labelText: 'Kode Barang (Opsional)')),
              TextField(controller: controller.namaController, decoration: InputDecoration(labelText: 'Nama Barang')),
              TextField(controller: controller.beliController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Harga Beli (Rp)')),
              TextField(controller: controller.jualController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Harga Jual (Rp)')),
              TextField(controller: controller.stokController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Jumlah Stok')),
              SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey, padding: EdgeInsets.symmetric(vertical: 14)),
                onPressed: () => isEdit ? controller.ubahBarang(id!) : controller.tambahBarang(),
                child: Text(isEdit ? 'SIMPAN PERUBAHAN' : 'TAMBAH BARANG', style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
