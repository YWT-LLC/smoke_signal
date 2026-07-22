/* smoke_signal
 * Copyright (c) 2026 YWT (Empathetech LLC). All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import '../../api/export.dart';
import '../../widgets/export.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:open_ui/open_ui.dart';

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
    return Consumer<EzCP>(
      builder: (_, EzCP config, __) => SmokeSignalScaffold(
        config,
        body: EzScreen(
          config,
          alignment: Alignment.center,
          child: EzScrollView(
            config,
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
              config.separator,

              // Submit button
              EzElevatedIconButton(
                config,
                onPressed: () async {
                  closeKeyboard(context);

                  final String email = emailController.text.trim();

                  // Don't do anything if the email is invalid
                  if (validateEmail(email) != null) {
                    await ezLogAlert(config, context: context, message: 'Invalid email!');
                    return;
                  }

                  // Attempt reset
                  try {
                    // await appUser.sendPasswordResetEmail();

                    if (context.mounted) {
                      await ezLogAlert(
                        config,
                        context: context,
                        message: 'Password reset email has been sent!',
                      );
                    }
                  } on Exception catch (e) {
                    if (context.mounted) {
                      await ezLogAlert(
                        config,
                        context: context,
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
        ),
        title: 'No problem!',
        drawerHeader: LoginHeader(config),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
