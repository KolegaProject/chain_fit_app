import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../domain/payment_result.dart';
import '../domain/payment_redirect_handler.dart';

class PaymentWebViewPage extends StatefulWidget {
  final String url;

  const PaymentWebViewPage({super.key, required this.url});

  @override
  State<PaymentWebViewPage> createState() => _PaymentWebViewPageState();
}

class _PaymentWebViewPageState extends State<PaymentWebViewPage> {
  late final WebViewController _controller;
  final _redirectHandler = const PaymentRedirectHandler();

  bool _loading = true;
  bool _handled = false;

  void _handleResult(PaymentResult result) {
    if (_handled) return;
    _handled = true;

    Navigator.pop(context, result);
  }

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (mounted) setState(() => _loading = true);
          },
          onPageFinished: (url) {
            if (mounted) setState(() => _loading = false);

            final result = _redirectHandler.resolve(url);
            if (result != null) {
              _handleResult(result);
            }
          },
          onNavigationRequest: (request) {
            final result = _redirectHandler.resolve(request.url);
            if (result != null) {
              _handleResult(result);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_loading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}