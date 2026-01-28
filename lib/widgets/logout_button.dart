/* smoke_signal
 * Copyright (c) 2026 Empathetech LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import '../../api/export.dart';

import 'package:flutter/material.dart';
import 'package:empathetech_flutter_ui/empathetech_flutter_ui.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) => EzIconLink(
        style: EzConfig.styles.bodyLarge!.copyWith(
          fontSize: EzConfig.styles.titleLarge!.fontSize,
        ),
        onTap: () => logout(context),
        hint: 'Logout',
        icon: const Icon(Icons.logout),
        label: 'Logout',
      );
}
