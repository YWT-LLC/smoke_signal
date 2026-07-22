/* smoke_signal
 * Copyright (c) 2026 YWT (Empathetech LLC). All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import '../widgets/export.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:open_ui/open_ui.dart';

class ErrorScreen extends StatefulWidget {
  const ErrorScreen({super.key});

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  // Set the page title //

  @override
  void initState() {
    super.initState();
    ezWindowNamer(ez404());
  }

  // Return the build //

  @override
  Widget build(BuildContext context) {
    return Consumer<EzCP>(
      builder: (_, EzCP config, __) => SmokeSignalScaffold(
        config,
        body: EzScreen(
          config,
          child: Center(
            child: EzScrollView(
              config,
              children: <Widget>[
                Text(
                  config.ezL10n.g404Wonder,
                  style: config.headlineStyle,
                  textAlign: TextAlign.center,
                ),
                config.separator,
                Text(
                  config.ezL10n.g404,
                  style: ezSubTitleStyle(config.styles),
                  textAlign: TextAlign.center,
                ),
                config.separator,
                Text(config.ezL10n.g404Note, style: config.labelStyle, textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
        drawerHeader: DrawerHeader(
          margin: EdgeInsets.all(config.marginVal),
          padding: EdgeInsets.zero,
          child: Center(
            child: EzScrollView(
              config,
              scrollDirection: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Nothing to see here', textAlign: TextAlign.center, style: config.titleStyle),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
