import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:health_app/Component/CustomComponent/CustomAppbar.dart';
import 'package:health_app/Screens/Documents/DocumentViewer.dart';
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
    var status = await Permission.storage.request();

    if (status.isGranted) {
      Directory? directory;
      if (Platform.isAndroid) {
        directory = await getExternalStorageDirectory();
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory != null) {
        final fileName = document['name'] as String?;
        final fileUrl = document['url'] as String?;

        if (fileName != null && fileUrl != null) {
          final savePath = '${directory.path}/$fileName';

          try {
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

  Future<void> _copyLocalFile(String filePath, String fileName) async {
    try {
      Directory? directory = await getExternalStorageDirectory();
      String newPath = "";

      //  path for Android
      List<String> folders = directory!.path.split("/");
      for (var i = 1; i < folders.length; i++) {
        String folder = folders[i];
        if (folder != "Android") {
          newPath += "/" + folder;
        } else {
          break;
        }
      }
      newPath = newPath + "/Documents";
      directory = Directory(newPath);

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      String newFilePath = "${directory.path}/$fileName";

      // Copy the file
      File localFile = File(filePath);
      await localFile.copy(newFilePath);
      Fluttertoast.showToast(
        msg: "File saved to: $newFilePath",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      print("Error copying file: $e");
      _showErrorDialog(context, "Error copying document: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppBar(
        actions: [],
        title: Text('Health Documents'),
        gradientColors: [
          Color.fromARGB(255, 100, 235, 194),
          Color.fromARGB(255, 150, 94, 247),
        ],
        automaticallyImplyLeading: true,
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
                final documentType = document['type'] as String? ?? '';
                final documentPath = document['path'] as String?;

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
                          child: documentType == 'pdf'
                              ? Icon(
                                  Icons.picture_as_pdf,
                                  color: Colors.deepPurple,
                                  size: screenWidth * 0.2,
                                )
                              : documentType == 'png' || documentType == 'jpg'
                                  ? Image.file(
                                      File(documentPath!),
                                      fit: BoxFit.cover,
                                      width: screenWidth * 0.2,
                                      height: screenHeight * 0.2,
                                    )
                                  : Icon(
                                      Icons.camera,
                                      color: Colors.deepPurple,
                                      size: screenWidth * 0.2,
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
                                final documentPath =
                                    widget.uploadedDocuments[index]['path'];
                                final fileName =
                                    widget.uploadedDocuments[index]['name'];

                                // Check if the path is a local file path
                                if (documentPath != null &&
                                    documentPath.startsWith('/data/')) {
                                  _copyLocalFile(documentPath, fileName);
                                } else {
                                  _downloadDocument(documentPath,
                                      fileName); // For remote URLs
                                }
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
          : Center(child: Image.asset('assets/images/nodata.png')),
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
