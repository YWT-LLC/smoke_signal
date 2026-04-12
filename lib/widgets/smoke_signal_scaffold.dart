/* smoke_signal
 * Copyright (c) 2026 Empathetech LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import '../utils/export.dart';
import './export.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:empathetech_flutter_ui/empathetech_flutter_ui.dart';

class SmokeSignalScaffold extends StatelessWidget {
  /// Recommended to use [EzScreen] at the top level
  final Widget body;

  /// [AppBar.title] passthrough (via [Text] widget)
  final String title;

  /// Recommended to use [DrawerHeader]
  final Widget drawerHeader;

  /// [SmokeSignalDrawer.extraButtons] passthrough
  final List<Widget>? extraButtons;

  /// [FloatingActionButton]s to add on top of the [EzUpdaterFAB]
  /// BYO spacing widgets
  final List<Widget>? fabs;

  /// Standardized [Scaffold] for all of Smoke Signals's screens
  const SmokeSignalScaffold(
    this.body, {
    super.key,
    this.title = appName,
    required this.drawerHeader,
    this.extraButtons,
    this.fabs,
  });

  @override
  Widget build(BuildContext context) {
    // Gather the contextual theme data //

    final double toolbarHeight =
        ezToolbarHeight(context: context, title: appName);

    // Define custom widgets //

    final Widget drawer = SmokeSignalDrawer(
      header: drawerHeader,
      extraButtons: extraButtons,
    );

    // Return the build //

    return EzAdaptiveParent(
      small: Consumer<EzConfigProvider>(
        builder: (_, EzConfigProvider config, __) => SelectionArea(
          child: Scaffold(
            key: ValueKey<int>(config.seed),
            appBar: PreferredSize(
              preferredSize: Size(double.infinity, toolbarHeight),
              child: AppBar(
                excludeHeaderSemantics: true,
                toolbarHeight: toolbarHeight,

                // Leading (aka left)
                leading: EzConfig.isLefty ? null : const EzBackAction(),
                leadingWidth: toolbarHeight,

                // Title
                title: Text(title, textAlign: TextAlign.center),
                centerTitle: true,
                titleSpacing: 0,

                // Actions (aka trailing aka right)
                actions:
                    EzConfig.isLefty ? const <Widget>[EzBackAction()] : null,
              ),
            ),

            // Drawer replaces leading (aka left)
            drawer: EzConfig.isLefty ? drawer : null,

            // End drawer replaces actions (aka trailing aka right)
            endDrawer: EzConfig.isLefty ? null : drawer,

            body: body,
            floatingActionButton: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                updater,
                if (fabs != null) ...fabs!,
                if (config.layout.showBackFAB &&
                    ezRootNav.currentState!.canPop()) ...<Widget>[
                  config.layout.spacer,
                  const EzBackFAB(),
                ],
              ],
            ),
            floatingActionButtonLocation: EzConfig.isLefty
                ? FloatingActionButtonLocation.startFloat
                : FloatingActionButtonLocation.endFloat,
            resizeToAvoidBottomInset: false,
          ),
        ),
      ),
    );
  }
}
