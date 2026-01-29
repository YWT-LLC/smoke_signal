/* smoke_signal
 * Copyright (c) 2026 Empathetech LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import '../../api/export.dart';
import '../../widgets/export.dart';

import 'package:flutter/material.dart';
import 'package:empathetech_flutter_ui/empathetech_flutter_ui.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetPasswordScreen> {
  // Define build data //

  final TextEditingController emailController = TextEditingController();

  // Set the page title //

  @override
  void initState() {
    super.initState();
    ezWindowNamer('Reset password');
  }

  // Return the build //

  @override
  Widget build(BuildContext context) {
    return SmokeSignalScaffold(
      EzScreen(
        EzScrollView(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Email form
            AutofillGroup(
              child: ConstrainedBox(
                constraints: ezTextFieldConstraints(context),
                child: TextFormField(
                  controller: emailController,
                  maxLines: 1,
                  autofillHints: const <String>[AutofillHints.email],
                  decoration: const InputDecoration(hintText: 'Enter email'),
                  validator: validateEmail,
                  autovalidateMode: AutovalidateMode.onUnfocus,
                ),
              ),
            ),
            const EzSeparator(),

            // Submit button
            EzElevatedIconButton(
              onPressed: () async {
                closeKeyboard(context);

                final String email = emailController.text.trim();

                // Don't do anything if the email is invalid
                if (validateEmail(email) != null) {
                  await ezLogAlert(context, message: 'Invalid email!');
                  return;
                }

                // Attempt reset
                try {
                  // await appUser.sendPasswordResetEmail();

                  if (context.mounted) {
                    await ezLogAlert(
                      context,
                      message: 'Password reset email has been sent!',
                    );
                  }
                } on Exception catch (e) {
                  if (context.mounted) {
                    await ezLogAlert(
                      context,
                      message: 'Failed to send password reset email:\n$e',
                    );
                  }
                }
              },
              icon: const Icon(Icons.mail),
              label: 'Send link',
            ),
          ],
        ),
        alignment: Alignment.center,
      ),
      title: 'No problem!',
      drawerHeader: const LoginHeader(),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
