/* smoke_signal
 * Copyright (c) 2026 YWT (Empathetech LLC). All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import '../utils/export.dart';
import './export.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:open_ui/open_ui.dart';

class SmokeSignalScaffold extends StatelessWidget {
  final EzCP config;
  final Widget body;
  final String title;
  final Widget drawerHeader;
  final List<Widget>? extraButtons;
  final List<Widget>? fabs;
  final bool isHome;

  const SmokeSignalScaffold(
    this.config, {
    super.key,
    required this.body,
    this.title = appName,
    required this.drawerHeader,
    this.extraButtons,
    this.fabs,
    this.isHome = false,
  });

  // Return the build //

  @override
  Widget build(BuildContext context) {
    return EzAdaptiveParent(
      small: Consumer<EzCP>(
        builder: (_, EzCP config, __) {
          final double toolbarHeight = ezToolbarHeight(config, context: context, title: appName);

          final Widget drawer = SmokeSignalDrawer(
            config,
            header: drawerHeader,
            extraButtons: extraButtons,
          );

          return EzScaffold(
            config,
            appBar: PreferredSize(
              preferredSize: Size(double.infinity, toolbarHeight),
              child: AppBar(
                excludeHeaderSemantics: true,
                toolbarHeight: toolbarHeight,

                // Leading (aka left)
                leading: config.isLefty ? null : EzBackAction(config),
                leadingWidth: toolbarHeight,

                // Title
                title: Text(title, textAlign: TextAlign.center),
                centerTitle: true,
                titleSpacing: 0,

                // Actions (aka trailing aka right)
                actions: config.isLefty ? <Widget>[EzBackAction(config)] : null,
              ),
            ),
            drawer: config.isLefty ? drawer : null,
            endDrawer: config.isLefty ? null : drawer,
            body: body,
            fabs: <Widget>[updater(config), if (fabs != null) ...fabs!, ...config.backFABs(isHome)],
          );
        },
      ),
    );
  }
}
