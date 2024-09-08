import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyAppSecPage extends StatefulWidget {
  final String mUrl;

  const MyAppSecPage({super.key, required this.mUrl});

  @override
  State<MyAppSecPage> createState() => _MyAppSecPageState();
}

class _MyAppSecPageState extends State<MyAppSecPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      // navigationBar: const CupertinoNavigationBar(
      //   middle: Text('AI Quote Generator'),
      // ),
      child: SafeArea(
        child: WebViewWidget(
          controller: WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..loadRequest(Uri.parse(widget.mUrl)),
        ),
      ),
    );
  }
}
