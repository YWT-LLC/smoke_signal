/* smoke_signal
 * Copyright (c) 2025 Empathetech LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:smoke_signal/main.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:empathetech_flutter_ui/empathetech_flutter_ui.dart';

void testSuite({
  Locale locale = english,
  bool isLefty = false,
}) =>
    testWidgets('home-screen', (WidgetTester tester) async {
      // Load the app //

      ezLog('Loading Smoke Signal');
      await tester.pumpWidget(const SmokeSignal());
      await tester.pumpAndSettle();
    });
