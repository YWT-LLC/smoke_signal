/* smoke_signal
 * Copyright (c) 2025 Empathetech LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import '../export.dart';
import '../../api/export.dart';
import '../../utils/export.dart';
import '../../widgets/export.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:empathetech_flutter_ui/empathetech_flutter_ui.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class SignalBoard extends StatefulWidget {
  const SignalBoard({super.key});

  @override
  State<SignalBoard> createState() => _SignalBoardState();
}

class _SignalBoardState extends State<SignalBoard> {
  // Gather theme data //

  late final Lang l10n = Lang.of(context)!;

  // Define build data //

  late Stream<List<Signal>> signalStream;

  // Define custom functions //

  void refresh() => setState(() {});

  void reload() => setState(() => signalStream = streamSignals());

  // Init //

  @override
  void initState() {
    super.initState();
    signalStream = streamSignals();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ezWindowNamer(context, 'Signal board');
  }

  // Return the build //

  @override
  Widget build(BuildContext context) {
    return SmokeSignalScaffold(
      title: 'Signals',
      drawerHeader: const LoggedInHeader(),
      extraButtons: const <Widget>[LogoutButton()],
      body: EzScreen(
        child: EzScrollView(
          children: <Widget>[
            // Signals the user is a member of
            StreamBuilder<List<Signal>>(
              stream: signalStream,
              builder: (_, AsyncSnapshot<List<Signal>> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const EzImage(
                      image: signalGif,
                      semanticLabel: 'Loading',
                    );
                  case ConnectionState.done:
                  default:
                    if (snapshot.hasError) {
                      ezLogAlert(context, message: snapshot.error.toString());
                      return const SizedBox.shrink();
                    }

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: snapshot.data!
                          .map((Signal signal) => SignalCard(
                                signal: signal,
                                reloadBoard: reload,
                              ))
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
      fab: FloatingActionButton(
        onPressed: () => context.goNamed(createSignalPath),
        tooltip: 'Create a new signal',
        child: Icon(PlatformIcons(context).add),
      ),
    );
  }
}
