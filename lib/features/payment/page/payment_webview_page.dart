import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewPage extends StatefulWidget {
  final String url;
  const PaymentWebViewPage({super.key, required this.url});

  @override
  State<PaymentWebViewPage> createState() => _PaymentWebViewPageState();
}

class _PaymentWebViewPageState extends State<PaymentWebViewPage> {
  late final WebViewController _controller;
  bool _loading = true;
  bool _alreadyHandled = false;

  bool _isSuccessUrl(String url) {
    final uri = Uri.tryParse(url);
    final status = uri?.queryParameters['transaction_status']?.toLowerCase();
    final code = uri?.queryParameters['status_code'];

    // Midtrans sukses biasanya settlement/capture
    if (status == 'settlement' || status == 'capture') return true;

    // beberapa callback/redirect pakai status_code=200
    if (code == '200') return true;

    // fallback: halaman finish
    if (url.toLowerCase().contains('/finish')) return true;

    return false;
  }

  void _handleSuccess(String url) {
    if (_alreadyHandled) return;
    _alreadyHandled = true;

    // balikin result "true" (sukses) ke halaman sebelumnya
    Navigator.pop(context, true);
  }

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _loading = true),
          onNavigationRequest: (request) {
            if (_isSuccessUrl(request.url)) {
              _handleSuccess(request.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onPageFinished: (url) {
            setState(() => _loading = false);
            if (_isSuccessUrl(url)) {
              _handleSuccess(url);
            }
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
