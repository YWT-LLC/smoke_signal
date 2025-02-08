/* smoke_signal
 * Copyright (c) 2022-2025 Empathetech LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:empathetech_ss_api/empathetech_ss_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:empathetech_flutter_ui/empathetech_flutter_ui.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

/// Map all Firebase [DocumentSnapshot] user docs to local [UserProfile]s
List<UserProfile> buildProfiles(
  List<DocumentSnapshot<Map<String, dynamic>>> userDocs,
) {
  return userDocs
      .map((DocumentSnapshot<Map<String, dynamic>> userDoc) =>
          UserProfile.buildFromDoc(userDoc))
      .toList();
}

/// [Widget] to display when there are on users found
Widget noUserCoin(BuildContext context) {
  return GestureDetector(
    onLongPress: () => showPlatformDialog(
      context: context,
      builder: (_) => EzAlertDialog(
        title: const Text('Nobody!', textAlign: TextAlign.center),
      ),
    ),
    child: Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        shape: BoxShape.circle,
      ),
      child: Icon(PlatformIcons(context).clear, size: 35),
    ),
  );
}

/// Displays a horizontally scrollable list of [UserProfile] pictures
Widget showUserPics(BuildContext context, List<UserProfile> profiles) {
  // Return clear icon on empty list
  if (profiles.isEmpty) return noUserCoin(context);

  return EzScrollView(
    scrollDirection: Axis.horizontal,
    children: profiles
        .map(
          (UserProfile profile) => GestureDetector(
            // On long press: display the user's profile name
            onLongPress: () => showPlatformDialog(
              context: context,
              builder: (_) => EzAlertDialog(
                content: Text(profile.name, textAlign: TextAlign.center),
              ),
            ),
            child: CircleAvatar(
              foregroundImage: CachedNetworkImageProvider(profile.avatarURL),
              minRadius: 35,
              maxRadius: 35,
            ),
          ),
        )
        .toList(),
  );
}

/// Displays a list of [UserProfile] pictures alongside their display names
Widget showUserProfiles(BuildContext context, List<UserProfile> profiles) {
  // Return clear icon on empty list
  if (profiles.isEmpty) return noUserCoin(context);

  return EzScrollView(
    children: profiles
        .map(
          (UserProfile profile) => Row(
            children: <Widget>[
              // Profile image/avatar
              CircleAvatar(
                foregroundImage: CachedNetworkImageProvider(profile.avatarURL),
                minRadius: 35,
                maxRadius: 35,
              ),

              // Display name
              Text(profile.name, textAlign: TextAlign.start),
            ],
          ),
        )
        .toList(),
  );
}

/// Wraps [PlatformListTile]s in an [EzScrollView] with a [title]
/// Optionally provide a height limit, 1/3 [widthOf] will be used as default
Widget addProfilesWindow({
  required BuildContext context,
  required String title,
  required List<PlatformListTile> items,
  double? customHeight,
}) {
  final ThemeData theme = Theme.of(context);

  return Container(
    width: widthOf(context),
    height: customHeight ?? heightOf(context) / 3.0,
    decoration: BoxDecoration(
      color: theme.colorScheme.primary,
      borderRadius: ezRoundEdge,
    ),
    child: Column(
      children: <Widget>[
        Text(title, style: theme.textTheme.titleLarge),
        EzScrollView(children: items),
      ],
    ),
  );
}
