import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class UploadDocument extends StatefulWidget {
  final Function(List<Map<String, dynamic>>) onDocumentsUploaded;

  UploadDocument({required this.onDocumentsUploaded});

  @override
  _UploadDocumentState createState() => _UploadDocumentState();
}

class _UploadDocumentState extends State<UploadDocument> {
  final picker = ImagePicker();
  bool _isLoading = false;

  Future<void> _pickImage(BuildContext context) async {
    var status = await Permission.camera.status;
    if (status.isDenied || status.isRestricted) {
      await Permission.camera.request();
    }

    if (await Permission.camera.isGranted) {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        File file = File(pickedFile.path);
        print('Picked file path: ${file.path}'); // Debug line
        _uploadFile(context, file, 'jpg');
      } else {
        _showErrorDialog(context, 'No image selected.');
      }
    } else {
      _showErrorDialog(context, 'Camera permission denied.');
    }
  }

  Future<void> _pickFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png'],
    );

    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      String fileType =
          result.files.single.extension ?? 'unknown'; // Determine file type

      if (fileType == 'jpg' || fileType == 'png') {
        // Handling for image files
        _uploadFile(context, file, fileType);
      } else if (fileType == 'pdf') {
        // Handling for PDFs
        _uploadFile(context, file, fileType);
      } else {
        _showErrorDialog(context, 'Unsupported file type.');
      }
    } else {
      _showErrorDialog(context, 'No file selected.');
    }
  }

  Future<void> _uploadFile(
      BuildContext context, File file, String fileType) async {
    setState(() {
      _isLoading = true;
    });

    try {
      String fileName = file.path.split('/').last;
      final uploadedFile = {
        'name': fileName,
        'url': file.path,
        'type': fileType,
        'date': DateTime.now().toString(),
      };

      widget.onDocumentsUploaded([uploadedFile]);
      Navigator.pop(context);
    } catch (e) {
      _showErrorDialog(context, 'Error uploading file: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.25,
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05, vertical: screenHeight * 0.01),
      child: Column(
        children: [
          if (_isLoading) ...[
            CircularProgressIndicator(),
            SizedBox(height: screenHeight * 0.02),
            Text('Uploading...',
                style: TextStyle(fontSize: screenWidth * 0.04)),
          ] else ...[
            ListTile(
              leading: Icon(
                Icons.camera_alt,
                color: Colors.deepPurple,
                size: screenWidth * 0.08,
              ),
              title: Text(
                'Upload from Camera',
                style: TextStyle(fontSize: screenWidth * 0.045),
              ),
              onTap: () => _pickImage(context),
            ),
            ListTile(
              leading: Icon(
                Icons.insert_drive_file,
                color: Colors.deepPurple,
                size: screenWidth * 0.08,
              ),
              title: Text(
                'Upload PDF, JPG, PNG',
                style: TextStyle(fontSize: screenWidth * 0.045),
              ),
              onTap: () => _pickFile(context),
            ),
          ],
        ],
      ),
    );
  }
}
