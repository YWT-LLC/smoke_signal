/* smoke_signal
 * Copyright (c) 2026 Empathetech LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import '../../api/export.dart';
import '../../utils/export.dart';
import '../../widgets/export.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:empathetech_flutter_ui/empathetech_flutter_ui.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettingsScreen> {
  // Define the build data //

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
          EzHeader(),

          // Display name
          EzTextBackground(
            Text(
              name,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
          EzConfig.margin,

          // Edit name
          EzElevatedIconButton(
            onPressed: () async {
              final dynamic shouldRefresh = await updateName('Caw');
              if (shouldRefresh == null) await refreshName();
            },
            icon: const Icon(Icons.edit),
            label: 'New name',
          ),
          const EzDivider(),

          // Profile image
          CircleAvatar(
            foregroundImage: CachedNetworkImageProvider(url),
            minRadius: 100,
            maxRadius: 100,
          ),
          EzConfig.margin,

          // Edit picture
          EzElevatedIconButton(
            onPressed: () async {
              final dynamic shouldRefresh = await updateAvatar(
                  'https://media.istockphoto.com/id/537389352/photo/tropical-rainforest.jpg?s=612x612&w=0&k=20&c=Gbweh81zqVDWihcJ5KA_41C0bufuIkgxZkDLc9h4HpI=');
              if (shouldRefresh == null) await refreshPic();
            },
            icon: const Icon(Icons.camera),
            label: 'New pic',
          ),
          EzConfig.spacer,
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
