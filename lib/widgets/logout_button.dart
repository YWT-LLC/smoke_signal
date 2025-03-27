/* smoke_signal
 * Copyright (c) 2025 Empathetech LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import '../../api/export.dart';

import 'package:flutter/material.dart';
import 'package:empathetech_flutter_ui/empathetech_flutter_ui.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return EzIconLink(
      style: textTheme.bodyLarge!.copyWith(
        fontSize: textTheme.titleLarge!.fontSize,
      ),
      onTap: () => logout(context),
      hint: 'Logout',
      icon: const Icon(Icons.logout),
      label: 'Logout',
    );
  }
}
