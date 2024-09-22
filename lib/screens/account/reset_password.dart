/* smoke_signal
 * Copyright (c) 2022-2024 Empathetech LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import '../../utils/export.dart';
import '../../widgets/export.dart';

import 'package:flutter/material.dart';
import 'package:empathetech_ss_api/empathetech_ss_api.dart';
import 'package:empathetech_flutter_ui/empathetech_flutter_ui.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetPasswordScreen> {
  // Gather theme data //

  late final Lang l10n = Lang.of(context)!;

  // Set the page title //

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setPageTitle('Reset password');
  }

  // Define build data //

  final TextEditingController emailController = TextEditingController();

  // Return the build //

  @override
  Widget build(BuildContext context) {
    return SmokeSignalScaffold(
      title: 'No problem!',
      drawerHeader: standardDrawerHeader,
      body: EzScreen(
        alignment: Alignment.center,
        child: EzScrollView(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Email form
            AutofillGroup(
              child: ConstrainedBox(
                constraints: textFieldConstraints(context),
                child: TextFormField(
                  controller: emailController,
                  maxLines: 1,
                  autofillHints: const <String>[AutofillHints.email],
                  decoration: const InputDecoration(hintText: 'Enter email'),
                  validator: emailValidator,
                  autovalidateMode: AutovalidateMode.onUnfocus,
                ),
              ),
            ),
            const EzSeparator(),

            // Submit button
            ElevatedButton.icon(
              onPressed: () async {
                closeKeyboard(context);

                final String email = emailController.text.trim();

                // Don't do anything if the email is invalid
                if (emailValidator(email) != null) {
                  logAlert(context, message: 'Invalid email!');
                  return;
                }

                // Attempt reset
                try {
                  await AppUser.auth.sendPasswordResetEmail(email: email);

                  if (context.mounted) {
                    logAlert(
                      context,
                      message: 'Password reset email has been sent!',
                    );
                  }
                } on Exception catch (e) {
                  if (context.mounted) {
                    logAlert(
                      context,
                      message: 'Failed to send password reset email:\n$e',
                    );
                  }
                }
              },
              icon: Icon(PlatformIcons(context).mail),
              label: const Text('Send link'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
