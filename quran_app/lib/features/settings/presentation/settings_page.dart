import 'package:flutter/material.dart';

/// Dil (F0-07) ve tema (F0-08) seçimleri buraya eklenir.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar')),
      body: const SizedBox.expand(),
    );
  }
}
