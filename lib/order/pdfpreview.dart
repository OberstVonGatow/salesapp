import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salesapp/services/pdf.dart';
import 'package:salesapp/services/provider.dart';
import '../services/models.dart';

class PDFPreviewScreen extends StatelessWidget {
  const PDFPreviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Order order = context.read<CurrentOrder>().order;
    PDFService pdf = PDFService();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auftrag'),
      ),
      body: Center(widthFactor: 1, child: pdf.showPDF(pdf.generatePDF(order))),
    );
  }
}
