/* smoke_signal
 * Copyright (c) 2022-2024 Empathetech LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import '../utils/export.dart';
import '../widgets/export.dart';

import 'package:flutter/material.dart';
import 'package:empathetech_flutter_ui/empathetech_flutter_ui.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  late final String loading = Lang.of(context)!.gLoading;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ezWindowNamer(loading, Theme.of(context).colorScheme.primary);
  }

  @override
  Widget build(BuildContext context) {
    return SmokeSignalScaffold(
      drawerHeader: const LoginHeader(),
      body: EzScreen(
        child: EzImage(image: signalGif, semanticLabel: loading),
      ),
    );
  }
}
