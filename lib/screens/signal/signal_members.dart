/* smoke_signal
 * Copyright (c) 2022-2024 Empathetech LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import '../../utils/export.dart';
import '../../widgets/export.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empathetech_ss_api/empathetech_ss_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:empathetech_flutter_ui/empathetech_flutter_ui.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class SignalMembersScreen extends StatefulWidget {
  final String title;
  final List<String> members;
  final List<String> activeMembers;
  final List<String> memberReqs;

  const SignalMembersScreen({
    super.key,
    required this.title,
    required this.members,
    required this.activeMembers,
    required this.memberReqs,
  });

  @override
  State<SignalMembersScreen> createState() => _SignalMembersScreenState();
}

class _SignalMembersScreenState extends State<SignalMembersScreen> {
  // Gather theme data //

  static const EzSpacer spacer = EzSpacer();
  final EzSpacer padder = EzSpacer(space: EzConfig.get(paddingKey));

  late final Lang l10n = Lang.of(context)!;

  // Define build data //

  final List<String> requestIDs = <String>[];

  late Stream<QuerySnapshot<Map<String, dynamic>>> userStream;

  // Define custom widgets //

  // Creates the widgets for the toggle list from the gathered profiles
  List<PlatformListTile> buildSwitchTiles(List<UserProfile> profiles) {
    final List<UserProfile> copy = List<UserProfile>.from(profiles);
    copy.removeWhere(
      (UserProfile profile) => profile.id == AppUser.account.uid,
    );

    return copy.map((UserProfile profile) {
      return PlatformListTile(
        // User info
        title: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Profile image/avatar
            CircleAvatar(
              foregroundImage: CachedNetworkImageProvider(profile.avatarURL),
              minRadius: 35,
              maxRadius: 35,
            ),
            padder,

            // Display name
            Text(profile.name, textAlign: TextAlign.start),
          ],
        ),

        // Toggle
        trailing: Checkbox(
          value: requestIDs.contains(profile.id),
          onChanged: (bool? value) {
            if (value == true) {
              setState(() => requestIDs.add(profile.id));
            } else {
              setState(() => requestIDs.remove(profile.id));
            }
          },
        ),
      );
    }).toList();
  }

  Widget sortUsers(List<UserProfile> profiles) {
    final List<UserProfile> memberProfiles = <UserProfile>[];
    final List<UserProfile> activeProfiles = <UserProfile>[];
    final List<UserProfile> pendingProfiles = <UserProfile>[];
    final List<UserProfile> unAddedProfiles = <UserProfile>[];

    for (final UserProfile profile in profiles) {
      if (widget.members.contains(profile.id)) {
        memberProfiles.add(profile);

        if (widget.activeMembers.contains(profile.id)) {
          activeProfiles.add(profile);
        }
      } else if (widget.memberReqs.contains(profile.id)) {
        pendingProfiles.add(profile);
      } else {
        unAddedProfiles.add(profile);
      }
    }

    final List<Widget> viewChildren = <Widget>[
      // Available members - show all pictures
      const Text('Available'),
      showUserPics(context, memberProfiles),
      spacer,

      // Active members - show all pictures
      const Text('Active'),
      showUserPics(context, activeProfiles),
      spacer,
    ];

    if (unAddedProfiles.isNotEmpty) {
      // Addable users - expandable, toggle-able, profiles
      viewChildren.addAll(
        <Widget>[
          addProfilesWindow(
            context: context,
            title: 'Add?',
            items: buildSwitchTiles(unAddedProfiles),
          ),
          spacer,

          // Submit button
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              requestMembers(
                context: context,
                title: widget.title,
                toAdd: requestIDs,
              );
            },
            icon: Icon(PlatformIcons(context).cloudUpload),
            label: const Text('Send requests'),
          ),
        ],
      );
    }

    return EzScrollView(children: viewChildren);
  }

  // Init //

  @override
  void initState() {
    super.initState();
    userStream = streamUsers();
  }

  // Set the page title //

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setPageTitle('Signal members');
  }

  // Return the build //

  @override
  Widget build(BuildContext context) {
    return SmokeSignalScaffold(
      title: '${widget.title} members',
      drawerHeader: signalDrawerHeader(context, () {}),
      body: EzScreen(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: userStream,
          builder: (
            BuildContext sBContext,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
          ) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const EzImage(
                  image: signalGif,
                  semanticLabel: 'Loading',
                );
              case ConnectionState.done:
              default:
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }
                return sortUsers(buildProfiles(snapshot.data!.docs));
            }
          },
        ),
      ),
    );
  }
}
