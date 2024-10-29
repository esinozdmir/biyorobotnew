import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FullImageScreen extends StatefulWidget {
  final String imageUrl;
  final String? title;
  final String? subtitle;
  final String? messageText;

  FullImageScreen({
    required this.imageUrl,
    this.title,
    this.subtitle,
    this.messageText,
  });

  @override
  _FullImageScreenState createState() => _FullImageScreenState();
}

class _FullImageScreenState extends State<FullImageScreen> {
  bool _showText = true; // Başlangıçta yazılar görünecek

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? ""),
      ),
      body: GestureDetector(
        onTap: () {
          // Resme tıklandığında yazıları göster/gizle
          setState(() {
            _showText = !_showText;
          });
        },
        child: Stack(
          children: [
            Center(
              child: PhotoView(
                imageProvider: NetworkImage(widget.imageUrl),
                backgroundDecoration: BoxDecoration(
                  color: Colors.white,
                ),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
              ),
            )
          ],
        ),
      ),
    );
  }
}
