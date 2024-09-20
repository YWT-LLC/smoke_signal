/* smoke_signal
 * Copyright (c) 2022-2024 Empathetech LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import '../export.dart';
import '../../utils/export.dart';
import '../../widgets/export.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:empathetech_ss_api/empathetech_ss_api.dart';
import 'package:empathetech_flutter_ui/empathetech_flutter_ui.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Gather theme data //

  static const EzSpacer spacer = EzSpacer();

  late final Lang l10n = Lang.of(context)!;

  // Define build data //

  final GlobalKey<FormState> emailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> passwordFormKey = GlobalKey<FormState>();

  late final TextEditingController emailController = TextEditingController();
  late final TextEditingController passwdController = TextEditingController();

  // Set the page title //

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setPageTitle('Login');
  }

  // Return the build //

  @override
  Widget build(BuildContext context) {
    return SmokeSignalScaffold(
      title: 'Welcome back!',
      drawerHeader: standardDrawerHeader,
      body: EzScreen(
        alignment: Alignment.center,
        child: EzScrollView(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Autofill group allows for password manager inputs and such
            AutofillGroup(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // Email field
                  ConstrainedBox(
                    constraints: textFieldConstraints(context),
                    child: TextFormField(
                      key: emailFormKey,
                      controller: emailController,
                      initialValue: 'Enter email',
                      autofillHints: const <String>[AutofillHints.email],
                      validator: emailValidator,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                  ),
                  spacer,

                  // Password field
                  ConstrainedBox(
                    constraints: textFieldConstraints(context),
                    child: TextFormField(
                      key: passwordFormKey,
                      controller: passwdController,
                      initialValue: 'Enter password',
                      obscureText: true,
                      autofillHints: const <String>[AutofillHints.password],
                    ),
                  ),
                ],
              ),
            ),
            spacer,

            // Forgot password option
            EzLink(
              'Forgot your password?',
              style: Theme.of(context).textTheme.bodyLarge,
              onTap: () => context.goNamed(resetPasswordPath),
              semanticsLabel: 'Forgot your password?',
            ),
            spacer,

            // Attempt login button
            ElevatedButton(
              onPressed: () async {
                closeKeyboard(context);

                // Don't attempt login if we know the input is invalid
                if (!emailFormKey.currentState!.validate()) {
                  logAlert(context, message: 'Invalid email!');
                  return;
                }

                await attemptLogin(
                  context,
                  emailController.text.trim(),
                  passwdController.text.trim(),
                );
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwdController.dispose();
    super.dispose();
  }
}
