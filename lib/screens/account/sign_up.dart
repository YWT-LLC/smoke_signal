/* smoke_signal
 * Copyright (c) 2022-2024 Empathetech LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import '../../utils/export.dart';
import '../../widgets/export.dart';

import 'package:flutter/material.dart';
import 'package:empathetech_ss_api/empathetech_ss_api.dart';
import 'package:empathetech_flutter_ui/empathetech_flutter_ui.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Gather theme data //

  static const EzSpacer spacer = EzSpacer();

  late final Lang l10n = Lang.of(context)!;

  // Set the page title //

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setPageTitle('Sign up');
  }

  // Define build data //

  final GlobalKey<FormState> emailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> passwordFormKey = GlobalKey<FormState>();

  final TextEditingController signUpEmailController = TextEditingController();
  final TextEditingController passwdController = TextEditingController();

  // Return the build //

  @override
  Widget build(BuildContext context) {
    return SmokeSignalScaffold(
      title: 'Welcome!',
      drawerHeader: standardDrawerHeader,
      body: EzScreen(
        alignment: Alignment.center,
        child: EzScrollView(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AutofillGroup(
              child: Column(
                children: <Widget>[
                  // Email field
                  TextFormField(
                    key: emailFormKey,
                    controller: signUpEmailController,
                    initialValue: 'Enter email',
                    autofillHints: const <String>[AutofillHints.email],
                    validator: emailValidator,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  spacer,

                  // Password field
                  TextFormField(
                    key: passwordFormKey,
                    controller: passwdController,
                    initialValue: 'Enter password',
                    obscureText: true,
                    autofillHints: const <String>[AutofillHints.password],
                  ),
                ],
              ),
            ),
            spacer,

            // Attempt sign up button
            ElevatedButton(
              onPressed: () async {
                closeKeyboard(context);

                // Don't do anything if the input is invalid
                if (!emailFormKey.currentState!.validate()) {
                  logAlert(context: context, message: 'Invalid email!');
                  return;
                }

                // Attempt login
                await attemptAccountCreation(
                  context,
                  signUpEmailController.text.trim(),
                  passwdController.text.trim(),
                );
              },
              child: const Text('Sign up'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    signUpEmailController.dispose();
    passwdController.dispose();
    super.dispose();
  }
}
