/* smoke_signal
 * Copyright (c) 2026 YWT (Empathetech LLC). All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import '../export.dart';
import '../../api/export.dart';
import '../../utils/export.dart';
import '../../widgets/export.dart';
import 'package:ywt_private/ywt_private.dart' as ywt;

import 'package:open_ui/open_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // Define the build data //

  bool showPwd = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwdController = TextEditingController();

  // Return the build //

  @override
  Widget build(BuildContext context) {
    return Consumer<EzCP>(
      builder: (_, EzCP config, __) => SmokeSignalScaffold(
        config,
        alignment: Alignment.center,
        body: EzScrollView(config, children: <Widget>[
          AutofillGroup(
            child: EzCol(children: <Widget>[
              // Email field
              EzTextField(
                constraints: ezTextFieldConstraints(context),
                controller: emailController,
                maxLines: 1,
                textAlign: TextAlign.start,
                hintText: 'Enter email',
                autofillHints: const <String>[AutofillHints.email],
                autovalidateMode: AutovalidateMode.onUnfocus,
                validator: validateEmail,
              ),
              config.spacer,

              // Password field
              EzTextField(
                // TODO: fix vertical align
                constraints: ezTextFieldConstraints(context),
                controller: passwdController,
                maxLines: 1,
                obscureText: !showPwd,
                textAlign: TextAlign.start,
                hintText: 'Enter password',
                autofillHints: const <String>[AutofillHints.password],
                suffixIcon: EzIconTouch(
                  config,
                  icon: showPwd ? Icons.visibility : Icons.visibility_off,
                  tooltip: showPwd ? 'Hide password' : 'Show password',
                  onPressed: () => setState(() => showPwd = !showPwd),
                ),
                validator: (_) => null,
                onFieldSubmitted: (String pwd) async {
                  final String? error = await login(
                    appUser: Provider.of<AppUserProvider>(context, listen: false),
                    email: emailController.text,
                    password: pwd,
                  );

                  if (context.mounted && error != null && error.isNotEmpty) {
                    ezLogAlert(config, context: context, message: error);
                  }
                },
              ),
            ]),
          ),
          config.separator,

          // Buttons
          EzRowCol.sym(config, children: <Widget>[
            // Login
            EzElevatedIconButton(
              config,
              onPressed: () async {
                closeKeyboard(context);
                if (validateEmail(emailController.text) != null) {
                  ezLogAlert(config, context: context, message: 'Invalid email!');
                  return;
                }

                final String? error = await login(
                  appUser: Provider.of<AppUserProvider>(context, listen: false),
                  email: emailController.text,
                  password: passwdController.text,
                );
                if (context.mounted && error != null && error.isNotEmpty) {
                  ezLogAlert(config, context: context, message: error);
                }
              },
              icon: const Icon(Icons.login),
              label: 'Login',
            ),
            config.swapSpacer,

            // Sign up
            EzElevatedIconButton(
              config,
              onPressed: () async {
                closeKeyboard(context);
                if (validateEmail(emailController.text) != null) {
                  ezLogAlert(config, context: context, message: 'Invalid email!');
                  return;
                }

                final String? error = await signUp(
                  appUser: Provider.of<AppUserProvider>(context, listen: false),
                  email: emailController.text,
                  password: passwdController.text,
                );
                if (context.mounted && error != null && error.isNotEmpty) {
                  ezLogAlert(config, context: context, message: error);
                }
              },
              icon: const Icon(Icons.edit_note_rounded),
              label: 'Sign up',
            ),
          ]),
          config.separator,

          // Forgot password
          EzLink(
            config,
            text: 'Forgot your password?',
            hint: 'Go to the password reset page',
            onTap: () => context.goNamed(resetPasswordPath),
          ),
          EzFooter(config, a11howPath: ywt.smokeSignalContributeA11),
        ]),
        drawerHeader: LoginHeader(config),
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
