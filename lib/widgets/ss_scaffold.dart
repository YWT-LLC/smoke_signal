/* smoke_signal
 * Copyright (c) 2025 Empathetech LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import '../utils/export.dart';
import './export.dart';

import 'package:flutter/material.dart';
import 'package:empathetech_flutter_ui/empathetech_flutter_ui.dart';

class SmokeSignalScaffold extends StatelessWidget {
  /// [AppBar.title] passthrough (via [Text] widget)
  final String title;

  /// Recommended to use [EzScreen] at the top level
  final Widget body;

  /// Recommended to use [DrawerHeader]
  final Widget drawerHeader;

  /// [SmokeSignalDrawer.extraButtons] passthrough
  final List<Widget>? extraButtons;

  /// [FloatingActionButton]
  final Widget? fab;

  /// Standardized [Scaffold] for all of Smoke Signals's screens
  const SmokeSignalScaffold({
    super.key,
    this.title = appTitle,
    required this.body,
    required this.drawerHeader,
    this.extraButtons,
    this.fab,
  });

  @override
  Widget build(BuildContext context) {
    // Gather the theme data //

    final double toolbarHeight = ezToolbarHeight(context, appTitle);

    final bool isLefty = EzConfig.get(isLeftyKey) ?? false;

    // Define custom widgets //

    final Widget drawer = SmokeSignalDrawer(
      header: drawerHeader,
      extraButtons: extraButtons,
    );

    // Return the build //

    return EzAdaptiveScaffold(
      small: SelectionArea(
        child: Scaffold(
          // AppBar
          appBar: PreferredSize(
            preferredSize: Size(double.infinity, toolbarHeight),
            child: AppBar(
              excludeHeaderSemantics: true,
              toolbarHeight: toolbarHeight,

              // Leading (aka left)
              leading: isLefty ? null : const EzBackAction(),
              leadingWidth: toolbarHeight,

              // Title
              title: Text(title),
              centerTitle: true,
              titleSpacing: 0,

              // Actions (aka trailing aka right)
              actions: isLefty ? const <Widget>[EzBackAction()] : null,
            ),
          ),

          // Drawer replaces leading (aka left)
          drawer: isLefty ? drawer : null,

          // End drawer replaces actions (aka trailing aka right)
          endDrawer: isLefty ? null : drawer,

          // Body
          body: body,

          // FAB
          floatingActionButton: fab,
          floatingActionButtonLocation: isLefty
              ? FloatingActionButtonLocation.startFloat
              : FloatingActionButtonLocation.endFloat,

          // Prevent the keyboard from pushing the body up
          resizeToAvoidBottomInset: false,
        ),
      ),
    );
  }
}
