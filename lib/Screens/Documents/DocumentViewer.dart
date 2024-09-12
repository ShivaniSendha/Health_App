import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:health_app/Component/CustomComponent/CustomAppbar.dart';

class Documentviewer extends StatelessWidget {
  final Map<String, dynamic> document;

  Documentviewer(this.document);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: CustomAppBar(
  actions: [], // You can add action buttons here if needed
  title: Text(
    document['name'],),
  gradientColors: [
    Color.fromARGB(255, 100, 235, 194), // Custom Start color
    Color.fromARGB(255, 150, 94, 247), // Custom End color
  ],
  automaticallyImplyLeading: true, // Shows a back button automatically
),

      body: document['type'] == 'pdf'
          ? PDFView(
              filePath: document['path'],
              autoSpacing: true, 
              pageFling: true, 
              pageSnap: true, 
            )
          : Center(
              child: Image.file(File(document['path'])), 
            ),
    );
  }
}
