import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class PDFViewerPage extends StatefulWidget {
  final String pdfPath; // This will be a network URL if from Firebase

  const PDFViewerPage({required this.pdfPath});

  @override
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  String? _localPath;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    // Load PDF from the network or assets
    if (widget.pdfPath.startsWith('http')) {
      _downloadAndSavePdf(widget.pdfPath);
    } else {
      _loadPdfFromAssets();
    }
  }

  // Method to download PDF from Firebase (network URL)
  Future<void> _downloadAndSavePdf(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final file = File('${(await getTemporaryDirectory()).path}/${url.split('/').last}');
        await file.writeAsBytes(response.bodyBytes);
        setState(() {
          _localPath = file.path;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to download PDF';
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = error.toString();
      });
    }
  }

  // Load PDFs from local assets (for local files)
  Future<void> _loadPdfFromAssets() async {
    try {
      final byteData = await rootBundle.load(widget.pdfPath);
      final file = File('${(await getTemporaryDirectory()).path}/${widget.pdfPath.split('/').last}');
      await file.writeAsBytes(byteData.buffer.asUint8List());
      setState(() {
        _localPath = file.path;
      });
    } catch (error) {
      setState(() {
        _errorMessage = error.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
        backgroundColor: Colors.blueGrey[600],
      ),
      body: _localPath != null
          ? PDFView(
        filePath: _localPath!,
      )
          : _errorMessage.isNotEmpty
          ? Center(child: Text(_errorMessage))
          : Center(child: CircularProgressIndicator()),
    );
  }
}
