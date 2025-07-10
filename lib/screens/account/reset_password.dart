/* smoke_signal
 * Copyright (c) 2025 Empathetech LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import '../../api/export.dart';
import '../../utils/export.dart';
import '../../widgets/export.dart';

import 'package:flutter/material.dart';
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
    ezWindowNamer(context, 'Reset password');
  }

  // Define build data //

  final TextEditingController emailController = TextEditingController();

  // Return the build //

  @override
  Widget build(BuildContext context) {
    return SmokeSignalScaffold(
      title: 'No problem!',
      drawerHeader: const LoginHeader(),
      body: EzScreen(
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
              icon: Icon(PlatformIcons(context).mail),
              label: 'Send link',
            ),
          ],
        ),
        alignment: Alignment.center,
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
