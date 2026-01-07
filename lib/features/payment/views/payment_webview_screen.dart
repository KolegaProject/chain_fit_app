import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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

  // Local notifications
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _paymentChannel =
      AndroidNotificationChannel(
    'payment_channel',
    'Payment Notifications',
    description: 'Notifikasi status pembayaran',
    importance: Importance.high,
  );

  bool _loading = true;
  bool _handled = false;

  Future<void> _initLocalNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _notifications.initialize(initSettings);

    // Android: buat notification channel
    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(_paymentChannel);

      // Android 13+ (Tiramisu): request permission
      await androidPlugin.requestNotificationsPermission();
    }

    final iosPlugin = _notifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
    if (iosPlugin != null) {
      await iosPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

Future<void> _showPaymentSuccessNotification() async {
  final details = NotificationDetails(
    android: AndroidNotificationDetails(
      _paymentChannel.id, 
      _paymentChannel.name,
      channelDescription: _paymentChannel.description,
      importance: Importance.high,
      priority: Priority.high,
    ),
    iOS: const DarwinNotificationDetails(
      presentAlert: true,
      presentSound: true,
      presentBadge: true,
    ),
  );

  await _notifications.show(
    1001,
    'Pembayaran berhasil ✅',
    'Terima kasih! Pembayaran kamu sudah dikonfirmasi.',
    details,
  );
}

  void _handleResult(PaymentResult result) {
    if (_handled) return;
    _handled = true;

    if (result == PaymentResult.success) {
      if (mounted) {
        // Local notification
        _showPaymentSuccessNotification();

        // UI feedback + redirect
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pembayaran berhasil ✅")),
        );
        Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (_) => false);
      }
    } else {
      Navigator.pop(context, result);
    }
  }

  @override
  void initState() {
    super.initState();

    // init local notifications
    _initLocalNotifications();

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
