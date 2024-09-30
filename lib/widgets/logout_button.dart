/* smoke_signal
 * Copyright (c) 2022-2024 Empathetech LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:flutter/material.dart';
import 'package:empathetech_ss_api/empathetech_ss_api.dart';
import 'package:empathetech_flutter_ui/empathetech_flutter_ui.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return EzLink(
      'Logout',
      style: textTheme.bodyLarge!.copyWith(
        fontSize: textTheme.titleLarge!.fontSize,
      ),
      icon: const Icon(Icons.logout),
      onTap: () => logout(context),
      semanticsLabel: 'Logout',
    );
  }
}
