/* smoke_signal
 * Copyright (c) 2026 YWT (Empathetech LLC). All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import './export.dart';

import 'package:open_ui/open_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SmokeSignalScaffold extends StatelessWidget {
  final EzCP config;
  final Widget body;
  final Alignment alignment;
  final Widget drawerHeader;
  final List<Widget>? extraButtons;
  final List<Widget>? fabs;
  final bool isHome;

  SmokeSignalScaffold(
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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) => EzAdaptiveParent(
        small: Consumer<EzCP>(
          builder: (_, EzCP config, __) {
            final Widget drawer = SmokeSignalDrawer(
              config,
              header: drawerHeader,
              extraButtons: extraButtons,
            );

            return EzScaffold(
              config,
              key: _scaffoldKey,
              drawer: config.isLefty ? drawer : null,
              endDrawer: config.isLefty ? null : drawer,
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
                          ? _scaffoldKey.currentState?.openDrawer()
                          : _scaffoldKey.currentState?.openEndDrawer(),
                    ),
                  )
                ]),
              ),
              fabs: <Widget>[
                updater(config),
                if (fabs != null) ...fabs!,
                ...config.backFABs(isHome),
              ],
            );
          },
        ),
      );
}
