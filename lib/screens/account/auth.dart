/* smoke_signal
 * Copyright (c) 2026 YWT (Empathetech LLC). All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import '../export.dart';
import '../../api/export.dart';
import '../../widgets/export.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:open_ui/open_ui.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // Define the build data //

  bool showPwd = false;

  late final TextEditingController emailController = TextEditingController();
  late final TextEditingController passwdController = TextEditingController();

  // Set the page title //

  @override
  void initState() {
    super.initState();
    ezWindowNamer('Auth');
  }
  // Return the build //

  @override
  Widget build(BuildContext context) {
    return Consumer<EzCP>(
      builder: (_, EzCP config, __) {
        final double bodyTextSize =
            config.bodyStyle?.fontSize ??
            EzCM.getDefault(config.isDark ? darkBodyFontSizeKey : lightBodyFontSizeKey);

        return SmokeSignalScaffold(
          config,
          body: EzScreen(
            config,
            alignment: Alignment.center,
            child: EzScrollView(
              config,
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
                          decoration: const InputDecoration(hintText: 'Enter email'),
                        ),
                      ),
                      config.spacer,

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
                              padding: EdgeInsets.symmetric(horizontal: config.marginVal),
                              child: InkWell(
                                onTap: () => setState(() => showPwd = !showPwd),
                                child: Icon(showPwd ? Icons.visibility : Icons.visibility_off),
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
                config.separator,

                // Buttons
                EzRowCol.sym(
                  config,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // Login
                    EzElevatedIconButton(
                      config,
                      onPressed: () async {
                        closeKeyboard(context);

                        // Don't do anything if the input is invalid
                        final String email = emailController.text.trim();

                        if (validateEmail(email) != null) {
                          await ezLogAlert(config, context: context, message: 'Invalid email!');
                          return;
                        }

                        await login(email: email, password: passwdController.text.trim());
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

                        // Don't do anything if the input is invalid
                        final String email = emailController.text.trim();

                        if (validateEmail(email) != null) {
                          await ezLogAlert(config, context: context, message: 'Invalid email!');
                          return;
                        }

                        // Attempt login
                        await signUp(email: email, password: passwdController.text.trim());
                      },
                      icon: const Icon(Icons.edit_note_rounded),
                      label: 'Sign up',
                    ),
                  ],
                ),
                config.separator,

                // Forgot password
                EzLink(
                  config,
                  text: 'Forgot your password?',
                  style: config.bodyStyle!,
                  onTap: () => context.goNamed(resetPasswordPath),
                  hint: 'Go to the password reset page',
                ),
                config.spacer,
              ],
            ),
          ),
          drawerHeader: LoginHeader(config),
        );
      },
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwdController.dispose();
    super.dispose();
  }
}
