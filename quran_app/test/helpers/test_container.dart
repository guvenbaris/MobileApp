import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/core/config/flavor.dart';
import 'package:quran_app/core/config/flavor_provider.dart';

/// Test sonunda kendini kapatan bir `ProviderContainer` oluşturur.
ProviderContainer createContainer({
  Flavor flavor = Flavor.dev,
  List<Override> overrides = const [],
}) {
  final container = ProviderContainer(
    overrides: [flavorProvider.overrideWithValue(flavor), ...overrides],
  );
  addTearDown(container.dispose);
  return container;
}
