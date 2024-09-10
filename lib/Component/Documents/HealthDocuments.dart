import 'dart:io';
import 'package:flutter/material.dart';
import 'package:health_app/Component/Documents/DocumentViewer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';

class HealthDocuments extends StatefulWidget {
  final List<Map<String, dynamic>> uploadedDocuments;

  HealthDocuments({required this.uploadedDocuments});

  @override
  _HealthDocumentsState createState() => _HealthDocumentsState();
}

class _HealthDocumentsState extends State<HealthDocuments> {
  void _deleteDocument(int index) {
    setState(() {
      widget.uploadedDocuments.removeAt(index);
    });
  }

  Future<void> _downloadDocument(
      BuildContext context, Map<String, dynamic> document) async {
    var status =
        await Permission.storage.request(); 

    if (status.isGranted) {
      Directory? directory;
      if (Platform.isAndroid) {
        directory = await getExternalStorageDirectory();
      } else {
        directory =
            await getApplicationDocumentsDirectory(); // For iOS, use this directory
      }

      if (directory != null) {
        final fileName = document['name'] as String?;
        final fileUrl = document['url'] as String?;

        if (fileName != null && fileUrl != null) {
          final savePath = '${directory.path}/$fileName';

          try {
            // Use Dio for downloading the file
            Dio dio = Dio();
            await dio.download(
              fileUrl,
              savePath,
              onReceiveProgress: (received, total) {
                if (total != -1) {
                  print((received / total * 100).toStringAsFixed(0) + "%");
                }
              },
            );

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Downloaded to $savePath')),
            );
          } catch (e) {
            _showErrorDialog(context, 'Error downloading file: $e');
          }
        } else {
          _showErrorDialog(context, 'File name or URL is null');
        }
      }
    } else {
      _showErrorDialog(context, 'Permission denied to access storage.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Health Documents'),
      ),
      body: widget.uploadedDocuments.isNotEmpty
          ? GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: screenWidth * 0.02,
                mainAxisSpacing: screenHeight * 0.01,
              ),
              itemCount: widget.uploadedDocuments.length,
              itemBuilder: (context, index) {
                final document = widget.uploadedDocuments[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Documentviewer(document),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: document['type'] == 'pdf'
                              ? Icon(
                                  Icons.picture_as_pdf,
                                  color: Colors.deepPurple,
                                  size: screenWidth * 0.2,
                                )
                              : Image.file(
                                  File(document['url']),
                                  fit: BoxFit.cover,
                                  width: screenWidth * 0.2,
                                  height: screenHeight * 0.2,
                                ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(screenWidth * 0.02),
                          child: Text(
                            document['name'],
                            style: TextStyle(
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(Icons.download),
                              color: Colors.green,
                              onPressed: () {
                                _downloadDocument(context, document);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              color: Colors.red,
                              onPressed: () {
                                _deleteDocument(index);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Text(
                'There is no document uploaded right now',
                style: TextStyle(fontSize: screenWidth * 0.045),
              ),
            ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
