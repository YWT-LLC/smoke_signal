/* smoke_signal
 * Copyright (c) 2022-2024 Empathetech LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import '../export.dart';
import '../../widgets/export.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:empathetech_flutter_ui/empathetech_flutter_ui.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // Gather theme data //

  late bool isDark = PlatformTheme.of(context)!.isDark;

// Return the build //

  @override
  Widget build(BuildContext context) {
    return SmokeSignalScaffold(
      drawerHeader: standardDrawerHeader,
      body: EzScreen(
        decorationImageKey:
            isDark ? darkBackgroundImageKey : lightBackgroundImageKey,
        child: EzScrollView(
          children: <Widget>[
            // Login
            ElevatedButton.icon(
              onPressed: () => context.go(loginRoute),
              icon: Icon(PlatformIcons(context).mail),
              label: const Text('Login'),
            ),
            const EzSpacer(),

            // Sign up
            ElevatedButton.icon(
              onPressed: () => context.go(signUpRoute),
              icon: Icon(PlatformIcons(context).mail),
              label: const Text('Sign up'),
            ),
            const EzSpacer(),
          ],
        ),
      ),
    );
  }
}
