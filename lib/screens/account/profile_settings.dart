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
  final EzSpacer padder = EzSpacer(space: EzConfig.get(paddingKey));

  final double spacing = EzConfig.get(spacingKey);
  final double margin = EzConfig.get(marginKey);

  late final Lang l10n = Lang.of(context)!;

  // Define build data //

  late String name = AppUser.account.displayName ?? defaultDisplayName;
  late String url = AppUser.account.photoURL ?? defaultAvatarURL;

  late final TextEditingController nameController =
      TextEditingController(text: name);

  late final TextEditingController urlController =
      TextEditingController(text: url);

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
    setPageTitle('Profile settings', Theme.of(context).colorScheme.primary);
  }

  // Return the build //

  @override
  Widget build(BuildContext context) {
    return SmokeSignalScaffold(
      title: 'Edit Profile',
      drawerHeader: const LoginHeader(),
      body: EzScreen(
        child: EzScrollView(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (spacing > margin) EzSpacer(space: spacing - margin),

            // Display name
            EzTextBackground(
              Text(
                name,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              useSurface: false,
            ),
            padder,

            // Edit name
            ElevatedButton.icon(
              onPressed: () async {
                final bool shouldRefresh = await editName(
                  context: context,
                  nameController: nameController,
                );
                if (shouldRefresh) await refreshName();
              },
              icon: Icon(PlatformIcons(context).edit),
              label: const Text('New name'),
            ),

            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: widthOf(context) * 0.75),
              child: const Divider(),
            ),

            // Profile image
            CircleAvatar(
              foregroundImage: CachedNetworkImageProvider(url),
              minRadius: 100,
              maxRadius: 100,
            ),
            padder,

            // Edit picture
            ElevatedButton.icon(
              onPressed: () async {
                final bool shouldRefresh = await editAvatar(
                  context: context,
                  urlController: urlController,
                );
                if (shouldRefresh) await refreshPic();
              },
              icon: Icon(PlatformIcons(context).photoCamera),
              label: const Text('New pic'),
            ),
            spacer,
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    urlController.dispose();
    super.dispose();
  }
}
