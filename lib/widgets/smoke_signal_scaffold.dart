/* smoke_signal
 * Copyright (c) 2026 YWT (Empathetech LLC). All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import './export.dart';

import 'package:open_ui/open_ui.dart';
import 'package:flutter/material.dart';

final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

class SmokeSignalScaffold extends StatelessWidget {
  final EzCP config;
  final Widget body;
  final Alignment alignment;
  final Widget drawerHeader;
  final List<Widget>? extraButtons;
  final List<Widget>? fabs;
  final bool isHome;

  const SmokeSignalScaffold(
    this.config, {
    super.key,
    required this.body,
    this.alignment = Alignment.topCenter,
    required this.drawerHeader,
    this.extraButtons,
    this.fabs,
    this.isHome = false,
  });

  // Return the build //

  @override
  Widget build(BuildContext context) => EzAdaptiveParent(
        small: EzScaffold(
          config,
          key: _drawerKey,
          drawer: config.isLefty
              ? SmokeSignalDrawer(
                  config,
                  header: drawerHeader,
                  extraButtons: extraButtons,
                )
              : null,
          endDrawer: config.isLefty
              ? null
              : SmokeSignalDrawer(
                  config,
                  header: drawerHeader,
                  extraButtons: extraButtons,
                ),
          body: EzScreen(
            config,
            safeArea: true,
            alignment: alignment,
            child: Stack(children: <Widget>[
              Align(alignment: alignment, child: Positioned.fill(child: body)),
              Positioned(
                top: 0,
                left: config.isLefty ? 0 : null,
                right: config.isLefty ? null : 0,
                child: EzIconButton(
                  config,
                  icon: EzIcon(config, Icons.menu),
                  tooltip: 'Open drawer',
                  onPressed: () => config.isLefty
                      ? _drawerKey.currentState?.openDrawer()
                      : _drawerKey.currentState?.openEndDrawer(),
                ),
              )
            ]),
          ),
          fabs: <Widget>[
            updater(config),
            if (fabs != null) ...fabs!,
            ...config.backFABs(isHome),
          ],
        ),
      );
}
