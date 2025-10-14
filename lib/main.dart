import 'package:flutter/material.dart';
import 'features/formulir_daftar_gym/views/formulir_daftar_gym_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PendaftaranGymPage(),
    );
  }
}
