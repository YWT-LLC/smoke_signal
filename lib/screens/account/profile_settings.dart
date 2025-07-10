/* smoke_signal
 * Copyright (c) 2025 Empathetech LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import '../../api/export.dart';
import '../../utils/export.dart';
import '../../widgets/export.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  final EzSpacer titleMargin = EzSpacer(space: EzConfig.get(marginKey));

  final double spacing = EzConfig.get(spacingKey);
  final double margin = EzConfig.get(marginKey);

  late final Lang l10n = Lang.of(context)!;

  // Define build data //

  late final AppUser user = Provider.of<AppUserProvider>(context).value!;

  late String name = user.displayName;
  late String url = user.avatarURL ?? defaultAvatarURL;

  late final TextEditingController nameController =
      TextEditingController(text: name);

  late final TextEditingController urlController =
      TextEditingController(text: url);

  // Define custom functions //

  /// Get the display name from source
  Future<void> refreshName() async {
    doNothing();
  }

  /// Get the pic URL from source
  Future<void> refreshPic() async {
    doNothing();
  }

  // Set the page title //

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ezWindowNamer(context, 'Profile settings');
  }

  // Return the build //

  @override
  Widget build(BuildContext context) {
    return SmokeSignalScaffold(
      title: 'Edit Profile',
      drawerHeader: const LoginHeader(),
      body: EzScreen(EzScrollView(
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
          ),
          titleMargin,

          // Edit name
          EzElevatedIconButton(
            onPressed: () async {
              final dynamic shouldRefresh = await updateName('Caw');
              if (shouldRefresh == null) await refreshName();
            },
            icon: Icon(PlatformIcons(context).edit),
            label: 'New name',
          ),
          const EzDivider(),

          // Profile image
          CircleAvatar(
            foregroundImage: CachedNetworkImageProvider(url),
            minRadius: 100,
            maxRadius: 100,
          ),
          titleMargin,

          // Edit picture
          EzElevatedIconButton(
            onPressed: () async {
              final dynamic shouldRefresh = await updateAvatar(
                  'https://media.istockphoto.com/id/537389352/photo/tropical-rainforest.jpg?s=612x612&w=0&k=20&c=Gbweh81zqVDWihcJ5KA_41C0bufuIkgxZkDLc9h4HpI=');
              if (shouldRefresh == null) await refreshPic();
            },
            icon: Icon(PlatformIcons(context).photoCamera),
            label: 'New pic',
          ),
          spacer,
        ],
      )),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    urlController.dispose();
    super.dispose();
  }
}
