// file: article_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleDetailScreen extends StatelessWidget {
  final String url;

  const ArticleDetailScreen({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chi tiết bài báo")),
      body: WebViewWidget(controller: WebViewController()..loadRequest(Uri.parse(url))),
    );
  }
}
