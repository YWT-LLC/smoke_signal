/* smoke_signal
 * Copyright (c) 2022-2025 Empathetech LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'export.dart';
import '../../utils/export.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empathetech_ss_api/empathetech_ss_api.dart';
import 'package:empathetech_flutter_ui/empathetech_flutter_ui.dart';

/// Enumerator for communicating with [HomeScreen] build should be returned
enum HomeBuildType { loading, auth, app }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Gather theme data //

  late final Lang l10n = Lang.of(context)!;

  // Define build data //

  late Stream<User?> authStream;

  /// Updates current build based on the current auth [type]
  Widget getBuild(HomeBuildType type) {
    switch (type) {
      case HomeBuildType.app:
        return const SignalBoard();

      case HomeBuildType.loading:
        return const LoadingScreen();

      case HomeBuildType.auth:
        return const AuthScreen();
    }
  }

  // Init //

  @override
  void initState() {
    super.initState();
    authStream = AppUser.auth.authStateChanges();
  }

  // Set the page title //

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ezWindowNamer('Home', Theme.of(context).colorScheme.primary);
  }

  // Return the build //

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: authStream,
      builder: (BuildContext sBContext, AsyncSnapshot<User?> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return getBuild(HomeBuildType.loading);

          case ConnectionState.done:
          default:
            // Check for user data, show auth build if invalid
            if (snapshot.hasError || !snapshot.hasData) {
              return getBuild(HomeBuildType.auth);
            }

            final User? currUser = snapshot.data;
            if (currUser == null) return getBuild(HomeBuildType.auth);

            // Merge current user with DB and initialize local class
            AppUser.account = currUser;
            AppUser.db = FirebaseFirestore.instance;

            // Load Smoke Signal!
            return getBuild(HomeBuildType.app);
        }
      },
    );
  }
}
