import 'package:chain_fit_app/features/gymPreview/page/gym_preview_page.dart';
import 'package:flutter/material.dart';
import 'features/formulir_daftar_gym/views/formulir_daftar_gym_view.dart';
import 'features/search_gym/views/search_gym_views.dart.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return shadcn.ShadcnApp(
      theme: shadcn.ThemeData(colorScheme: shadcn.ColorSchemes.lightDefaultColor),
      debugShowCheckedModeBanner: false,

      //home: PendaftaranGymPage(),
      home: GymPreviewPage(),
    );
  }
}
