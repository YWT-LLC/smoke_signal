/* smoke_signal
 * Copyright (c) 2026 YWT (Empathetech LLC). All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import '../utils/export.dart';

import 'package:open_ui/open_ui.dart';
import 'package:material_ui/material_ui.dart';

class LogoutButton extends StatelessWidget {
  final EzCP config;

  const LogoutButton(this.config, {super.key});

  @override
  Widget build(BuildContext context) => EzIconLink(
        config,
        style: config.subTitleStyle,
        onTap: () => logout(context),
        hint: 'Logout',
        icon: EzIcon(config, Icons.logout),
        label: 'Logout',
      );
}
