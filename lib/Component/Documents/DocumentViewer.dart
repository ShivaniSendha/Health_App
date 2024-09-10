import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class Documentviewer extends StatelessWidget {
  final Map<String, dynamic> document;

  Documentviewer(this.document);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(document['name']),
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
