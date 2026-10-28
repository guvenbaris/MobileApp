import 'package:flutter/material.dart';

import 'core/config/flavor.dart';

class QuranApp extends StatelessWidget {
  const QuranApp({required this.flavor, super.key});

  final Flavor flavor;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: flavor.isDev,
      home: const Scaffold(body: SizedBox.shrink()),
    );
  }
}
