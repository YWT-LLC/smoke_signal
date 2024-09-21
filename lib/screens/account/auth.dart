/* smoke_signal
 * Copyright (c) 2022-2024 Empathetech LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import '../export.dart';
import '../../widgets/export.dart';
import '../../utils/export.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:empathetech_ss_api/empathetech_ss_api.dart';
import 'package:empathetech_flutter_ui/empathetech_flutter_ui.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // Gather theme data //

  static const EzSpacer spacer = EzSpacer();
  static const EzSeparator separator = EzSeparator();

  late final double bodyTextSize =
      Theme.of(context).textTheme.bodyLarge?.fontSize ?? 16;

  late final Lang l10n = Lang.of(context)!;

  // Define build data //

  final GlobalKey<FormState> emailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> passwordFormKey = GlobalKey<FormState>();

  bool showPwd = false;

  late final TextEditingController emailController = TextEditingController();
  late final TextEditingController passwdController = TextEditingController();

  // Set the page title //

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setPageTitle('Auth');
  }

  // Return the build //

  @override
  Widget build(BuildContext context) {
    return SmokeSignalScaffold(
      drawerHeader: standardDrawerHeader,
      body: EzScreen(
        alignment: Alignment.center,
        child: EzScrollView(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
                      maxLines: 1,
                      autofillHints: const <String>[AutofillHints.email],
                      validator: emailValidator,
                      autovalidateMode: AutovalidateMode.onUnfocus,
                      decoration:
                          const InputDecoration(hintText: 'Enter email'),
                    ),
                  ),
                  spacer,

                  // Password field
                  ConstrainedBox(
                    constraints: textFieldConstraints(context),
                    child: TextFormField(
                      key: passwordFormKey,
                      controller: passwdController,
                      maxLines: 1,
                      autofillHints: const <String>[AutofillHints.password],
                      obscureText: !showPwd,
                      decoration: InputDecoration(
                        hintText: 'Enter password',
                        suffixIcon: Padding(
                          padding: EdgeInsets.only(
                            right: EzConfig.get(marginKey),
                          ),
                          child: InkWell(
                            onTap: () => setState(() => showPwd = !showPwd),
                            child: Icon(showPwd
                                ? PlatformIcons(context).eyeSolid
                                : PlatformIcons(context).eyeSlashSolid),
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
            separator,

            // Buttons
            EzRowCol.sym(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Sign up
                ElevatedButton.icon(
                  onPressed: () async {
                    closeKeyboard(context);

                    // Don't do anything if the input is invalid
                    if (!emailFormKey.currentState!.validate()) {
                      logAlert(context, message: 'Invalid email!');
                      return;
                    }

                    // Attempt login
                    await attemptAccountCreation(
                      context,
                      emailController.text.trim(),
                      passwdController.text.trim(),
                    );
                  },
                  icon: const Icon(Icons.edit_note_rounded),
                  label: const Text('Sign up'),
                ),
                const EzSwapSpacer(),

                // Login
                ElevatedButton.icon(
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
                  icon: const Icon(Icons.login),
                  label: const Text('Login'),
                ),
              ],
            ),
            separator,

            // Forgot password
            EzLink(
              'Forgot your password?',
              style: Theme.of(context).textTheme.bodyLarge,
              onTap: () => context.goNamed(resetPasswordPath),
              semanticsLabel: 'Forgot your password?',
            ),
            spacer,
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
