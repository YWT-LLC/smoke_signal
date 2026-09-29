/* smoke_signal
 * Copyright (c) 2026 YWT (Empathetech LLC). All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import '../export.dart';
import '../../api/export.dart';
import '../../widgets/export.dart';
import 'package:ywt_private/ywt_private.dart' as ywt;

import 'package:open_ui/open_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class SignalBoard extends StatefulWidget {
  const SignalBoard({super.key});

  @override
  State<SignalBoard> createState() => _SignalBoardState();
}

class _SignalBoardState extends State<SignalBoard> {
  @override
  Widget build(BuildContext context) {
    return Consumer<EzCP>(
      builder: (_, EzCP config, __) => SmokeSignalScaffold(
        config,
        body: EzScrollView(config, children: <Widget>[
          // Signals the user is a member of
          StreamBuilder<List<Signal>>(
            stream: streamSignals(),
            builder: (_, AsyncSnapshot<List<Signal>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return EzLoadingGlass(config);

                default:
                  if (snapshot.hasError) {
                    ezLogAlert(config, context: context, message: snapshot.error.toString());
                    return const SizedBox.shrink();
                  }

                  return EzCol(
                    children: (snapshot.data ?? <Signal>[])
                        .map((Signal signal) => SignalCard(
                              config,
                              signal: signal,
                              reloadBoard: () => setState(() {}),
                            ))
                        .toList(),
                  );
              }
            },
          ),
          EzFooter(config, a11howPath: ywt.smokeSignalContributeA11),
        ]),
        drawerHeader: LoggedInHeader(config),
        extraButtons: <Widget>[LogoutButton(config)],
        fabs: <Widget>[
          config.spacer,
          FloatingActionButton(
            onPressed: () => context.goNamed(createSignalPath),
            tooltip: 'Create a new signal',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
