/* smoke_signal
 * Copyright (c) 2026 Empathetech LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import '../export.dart';
import '../../api/export.dart';
import '../../widgets/export.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:empathetech_flutter_ui/empathetech_flutter_ui.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // Define the build data //

  late final double bodyTextSize =
      Theme.of(context).textTheme.bodyLarge?.fontSize ?? 16;

  bool showPwd = false;

  late final TextEditingController emailController = TextEditingController();
  late final TextEditingController passwdController = TextEditingController();

  // Set the page title //

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ezWindowNamer(context, 'Auth');
  }

  // Return the build //

  @override
  Widget build(BuildContext context) {
    return SmokeSignalScaffold(
      drawerHeader: const LoginHeader(),
      body: EzScreen(
        EzScrollView(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AutofillGroup(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // Email field
                  ConstrainedBox(
                    constraints: ezTextFieldConstraints(context),
                    child: TextFormField(
                      controller: emailController,
                      maxLines: 1,
                      autofillHints: const <String>[AutofillHints.email],
                      validator: validateEmail,
                      autovalidateMode: AutovalidateMode.onUnfocus,
                      decoration:
                          const InputDecoration(hintText: 'Enter email'),
                    ),
                  ),
                  EzConfig.spacer,

                  // Password field
                  ConstrainedBox(
                    constraints: ezTextFieldConstraints(context),
                    child: TextFormField(
                      controller: passwdController,
                      maxLines: 1,
                      autofillHints: const <String>[AutofillHints.password],
                      obscureText: !showPwd,
                      decoration: InputDecoration(
                        hintText: 'Enter password',
                        suffixIcon: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: EzConfig.marginVal),
                          child: InkWell(
                            onTap: () => setState(() => showPwd = !showPwd),
                            child: Icon(showPwd
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                        ),
                        suffixIconConstraints: BoxConstraints(
                          minWidth: bodyTextSize,
                          minHeight: bodyTextSize,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            EzConfig.separator,

            // Buttons
            EzRowCol.sym(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Login
                EzElevatedIconButton(
                  onPressed: () async {
                    closeKeyboard(context);

                    // Don't do anything if the input is invalid
                    final String email = emailController.text.trim();

                    if (validateEmail(email) != null) {
                      await ezLogAlert(context, message: 'Invalid email!');
                      return;
                    }

                    await login(
                      email: email,
                      password: passwdController.text.trim(),
                    );
                  },
                  icon: const Icon(Icons.login),
                  label: 'Login',
                ),
                const EzSwapSpacer(),

                // Sign up
                EzElevatedIconButton(
                  onPressed: () async {
                    closeKeyboard(context);

                    // Don't do anything if the input is invalid
                    final String email = emailController.text.trim();

                    if (validateEmail(email) != null) {
                      await ezLogAlert(context, message: 'Invalid email!');
                      return;
                    }

                    // Attempt login
                    await signUp(
                      email: email,
                      password: passwdController.text.trim(),
                    );
                  },
                  icon: const Icon(Icons.edit_note_rounded),
                  label: 'Sign up',
                ),
              ],
            ),
            EzConfig.separator,

            // Forgot password
            EzLink(
              'Forgot your password?',
              style: Theme.of(context).textTheme.bodyLarge!,
              onTap: () => context.goNamed(resetPasswordPath),
              hint: 'Go to the password reset page',
            ),
            EzConfig.spacer,
          ],
        ),
        alignment: Alignment.center,
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
