/* smoke_signal
 * Copyright (c) 2022-2024 Empathetech LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import '../export.dart';
import '../../utils/export.dart';
import '../../widgets/export.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empathetech_ss_api/empathetech_ss_api.dart';
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

  late Stream<QuerySnapshot<Map<String, dynamic>>> signalStream;
  late Stream<QuerySnapshot<Map<String, dynamic>>> requestStream;

  // Define custom functions //

  void refresh() => setState(() {});

  void reload() => setState(() {
        signalStream = streamSignals(membersPath);
        requestStream = streamSignals(memberRequestsPath);
      });

  // Init //

  @override
  void initState() {
    super.initState();
    signalStream = streamSignals(membersPath);
    requestStream = streamSignals(memberRequestsPath);
  }

  // Set the page title //

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setPageTitle('Signal board');
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
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: signalStream,
              builder: (
                BuildContext sBContext,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
              ) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const EzImage(
                      image: signalGif,
                      semanticLabel: 'Loading',
                    );
                  case ConnectionState.done:
                  default:
                    if (snapshot.hasError) {
                      logAlert(context,
                          message: snapshot.error
                              .toString()); // TODO: await (future builder or somethin?)
                      return const SizedBox.shrink();
                    }

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment
                          .spaceEvenly, // TODO: Are you sure about that?
                      children: snapshot.data!.docs
                          .map((DocumentSnapshot<Map<String, dynamic>>
                                  signalDoc) =>
                              Signal.buildSignal(signalDoc, reload))
                          .toList(),
                    );
                }
              },
            ),

            // Signal requests pending the user's approval
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: requestStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const SizedBox.shrink();
                  case ConnectionState.done:
                  default:
                    if (snapshot.hasError) {
                      logAlert(context,
                          message: snapshot.error
                              .toString()); // TODO: await (future builder or somethin?)
                      return const SizedBox.shrink();
                    }

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment
                          .spaceEvenly, // TODO: Are you sure about that?
                      children: snapshot.data!.docs
                          .map((DocumentSnapshot<Map<String, dynamic>>
                                  signalDoc) =>
                              Signal.buildSignal(signalDoc, reload))
                          .toList(),
                    );
                }
              },
            ),
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
