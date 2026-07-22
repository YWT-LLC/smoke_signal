/* smoke_signal
 * Copyright (c) 2026 YWT (Empathetech LLC). All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import '../export.dart';
import '../../api/export.dart';
import '../../widgets/export.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:open_ui/open_ui.dart';

class SignalBoard extends StatefulWidget {
  const SignalBoard({super.key});

  @override
  State<SignalBoard> createState() => _SignalBoardState();
}

class _SignalBoardState extends State<SignalBoard> {
  // Define build data //

  late Stream<List<Signal>> signalStream;

  // Define custom functions //

  void refresh() => setState(() {});

  void reload() => setState(() => signalStream = streamSignals());

  // Init //

  @override
  void initState() {
    super.initState();
    ezWindowNamer('Signal board');
    signalStream = streamSignals();
  }

  // Return the build //

  @override
  Widget build(BuildContext context) {
    return Consumer<EzCP>(
      builder: (_, EzCP config, __) => SmokeSignalScaffold(
        config,
        body: EzScreen(
          config,
          child: EzScrollView(
            config,
            children: <Widget>[
              // Signals the user is a member of
              StreamBuilder<List<Signal>>(
                stream: signalStream,
                builder: (_, AsyncSnapshot<List<Signal>> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const EzImage(image: signalGif, semanticLabel: 'Loading');

                    case ConnectionState.done:
                    default:
                      if (snapshot.hasError) {
                        ezLogAlert(config, context: context, message: snapshot.error.toString());
                        return const SizedBox.shrink();
                      }

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: snapshot.data!
                            .map(
                              (Signal signal) =>
                                  SignalCard(config, signal: signal, reloadBoard: reload),
                            )
                            .toList(),
                      );
                  }
                },
              ),

              // // Signal requests pending the user's approval
              // StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              //   stream: requestStream,
              //   builder: (BuildContext context,
              //       AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              //     switch (snapshot.connectionState) {
              //       case ConnectionState.waiting:
              //         return const SizedBox.shrink();
              //       case ConnectionState.done:
              //       default:
              //         if (snapshot.hasError) {
              //           ezLogAlert(context, message: snapshot.error.toString());
              //           return const SizedBox.shrink();
              //         }

              //         return Column(
              //           mainAxisSize: MainAxisSize.min,
              //           children: snapshot.data!.docs
              //               .map((DocumentSnapshot<Map<String, dynamic>>
              //                       signalDoc) =>
              //                   Signal.buildSignal(signalDoc, reload))
              //               .toList(),
              //         );
              //     }
              //   },
              // ),
            ],
          ),
        ),
        title: 'Signals',
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
