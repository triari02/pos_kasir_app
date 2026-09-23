import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ReceiptService {
  // Fungsi untuk membuat layout struk belanja dalam format PDF
  static Future<Uint8List> generateReceipt(Map<String, dynamic> transaksi) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80, // Ukuran kertas struk thermal 80mm
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start, // PARAMETER YANG BENAR DI SINI
            children: [
              pw.Center(
                child: pw.Text("TOKO MAJU JAYA", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
              ),
              pw.Center(child: pw.Text("Jl. Merdeka No. 123")),
              pw.Divider(borderStyle: pw.BorderStyle.dashed),
              pw.Text("Nota: ${transaksi['invoice']}"),
              pw.Text("Tanggal: ${transaksi['tanggal']}"),
              pw.Divider(borderStyle: pw.BorderStyle.dashed),
              
              // Looping Item Belanja
              ...List.generate(transaksi['items'].length, (index) {
                final item = transaksi['items'][index];
                return pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("${item['nama']} x${item['qty']}"),
                    pw.Text("${item['subtotal']}"),
                  ],
                );
              }),
              
              pw.Divider(borderStyle: pw.BorderStyle.dashed),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("TOTAL", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text("${transaksi['total']}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ],
              ),
            ],
          );
        },
      ),
    );
    return pdf.save();
  }

  // Fungsi untuk menampilkan dialog Print Preview bawaan Flutter
  static void showPreview(Map<String, dynamic> transaksi) async {
    final receiptData = await generateReceipt(transaksi);
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => receiptData,
      name: 'Struk-${transaksi['invoice']}',
    );
  }
}
