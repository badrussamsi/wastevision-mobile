import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wastevision_mobile/main.dart';

void main() {
  testWidgets('HomePage shows initial WasteVision UI', (WidgetTester tester) async {
    // Configure a larger virtual device size to avoid layout overflow in tests.
    tester.binding.window.physicalSizeTestValue = const ui.Size(1080, 1920);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    addTearDown(() {
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });

    // Build the WasteVision app and trigger a frame.
    await tester.pumpWidget(const WasteVisionApp());

    // Verify header text is shown.
    expect(find.text('Classify your waste with AI'), findsOneWidget);

    // Verify helper text is shown.
    expect(
      find.textContaining('Take a photo or choose from gallery'),
      findsOneWidget,
    );

    // Verify primary action buttons exist.
    expect(find.text('Gallery'), findsOneWidget);
    expect(find.text('Camera'), findsOneWidget);

    // Verify default preview state.
    expect(find.text('No image selected'), findsOneWidget);

    // Verify classify button exists.
    expect(find.text('Classify (dummy)'), findsOneWidget);
  });
}
