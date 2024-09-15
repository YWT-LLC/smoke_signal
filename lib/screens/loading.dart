/* smoke_signal
 * Copyright (c) 2022-2024 Empathetech LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import '../utils/export.dart';

import 'package:empathetech_flutter_ui/empathetech_flutter_ui.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  late double buttonSpacer = EzConfig.prefs[buttonSpacingKey];

  @override
  Widget build(BuildContext context) {
    return EzScaffold(
      background: BoxDecoration(color: Color(EzConfig.prefs[backColorKey])),
      appBar: EzAppBar(
        title: Text(
          appTitle,
          style: buildTextStyle(styleKey: titleStyleKey),
        ),
      ),
      body: ezView(
        context: context,
        background: BoxDecoration(
          image: DecorationImage(image: EzImage.getProvider(backImageKey)),
        ),
        body: loadingMessage(
          context: context,
          image: EzImage(prefsKey: signalImageKey),
        ),
      ),
    );
  }
}
