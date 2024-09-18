/* smoke_signal
 * Copyright (c) 2022-2024 Empathetech LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import '../../utils/export.dart';
import '../../widgets/export.dart';

import 'package:flutter/material.dart';
import 'package:empathetech_ss_api/empathetech_ss_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:empathetech_flutter_ui/empathetech_flutter_ui.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettingsScreen> {
  // Gather theme data //

  static const EzSpacer spacer = EzSpacer();

  late final double spacing = EzConfig.get(spacingKey);
  late final double margin = EzConfig.get(marginKey);

  late final Lang l10n = Lang.of(context)!;

  // Define build data //

  late String name = AppUser.account.displayName ?? defaultDisplayName;
  late String url = AppUser.account.photoURL ?? defaultAvatarURL;

  // Define custom functions //

  /// Get the display name from source
  Future<void> refreshName() async {
    final String newName = await getName();
    setState(() => name = newName);
  }

  /// Get the pic URL from source
  Future<void> refreshPic() async {
    final String newUrl = await getAvatar();
    setState(() => url = newUrl);
  }

  // Set the page title //

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setPageTitle('Profile settings');
  }

  // Return the build //

  @override
  Widget build(BuildContext context) {
    return SmokeSignalScaffold(
      title: 'Edit Profile',
      drawerHeader: standardDrawerHeader,
      body: EzScreen(
        child: EzScrollView(
          children: <Widget>[
            if (spacing > margin) EzSpacer(space: spacing - margin),

            // Profile image
            CircleAvatar(
              foregroundImage: CachedNetworkImageProvider(url),
              minRadius: 100,
              maxRadius: 100,
            ),
            spacer,

            // Edit picture
            ElevatedButton.icon(
              onPressed: () async {
                final bool shouldRefresh = await editAvatar(context);
                if (shouldRefresh) refreshPic();
              },
              icon: Icon(PlatformIcons(context).photoCamera),
              label: const Text('New pic'),
            ),
            spacer,

            // Display name
            Text(name, style: Theme.of(context).textTheme.titleLarge),
            spacer,

            // Edit name
            ElevatedButton.icon(
              onPressed: () async {
                final bool shouldRefresh = await editName(context);
                if (shouldRefresh) refreshName();
              },
              icon: Icon(PlatformIcons(context).edit),
              label: const Text('New name'),
            ),
            spacer,
          ],
        ),
      ),
    );
  }
}
