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
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class SignalMembersScreen extends StatefulWidget {
  final Signal signal;

  const SignalMembersScreen({super.key, required this.signal});

  @override
  State<SignalMembersScreen> createState() => _SignalMembersScreenState();
}

class _SignalMembersScreenState extends State<SignalMembersScreen> {
  // Gather theme data //

  static const EzSpacer spacer = EzSpacer();
  final double iconSize = EzConfig.get(iconSizeKey);

  late final Lang l10n = Lang.of(context)!;

  // Define build data //

  late final AppUser appUser = Provider.of<AppUserProvider>(context).value!;

  late Stream<List<User>> userStream;

  late final Signal signal = widget.signal;
  final List<User> requestedUsers = <User>[];

  // Define custom widgets //

  // Creates the widgets for the toggle list from the gathered profiles
  List<PlatformListTile> buildSwitchTiles(List<User> users) {
    final List<User> copy = List<User>.from(users);
    copy.removeWhere((User user) => user == appUser);

    return copy.map((User user) {
      return PlatformListTile(
        // User info
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Profile image/avatar
            CircleAvatar(
              foregroundImage: user.avatarURL != null
                  ? CachedNetworkImageProvider(user.avatarURL!)
                  : null,
              minRadius: iconSize,
              maxRadius: iconSize,
            ),
            EzSpacer(space: EzConfig.get(marginKey)),

            // Display name
            Text(user.displayName, textAlign: TextAlign.start),
          ],
        ),

        // Toggle
        trailing: Checkbox(
          value: requestedUsers.contains(user),
          onChanged: (bool? value) {
            if (value == true) {
              setState(() => requestedUsers.add(user));
            } else {
              setState(() => requestedUsers.remove(user));
            }
          },
        ),
      );
    }).toList();
  }

  Widget sortUsers(List<User> users) {
    final List<User> memberProfiles = <User>[];
    final List<User> activeProfiles = <User>[];
    // final List<User> pendingProfiles = <User>[];
    final List<User> unAddedProfiles = <User>[];

    for (final User user in users) {
      if (signal.members.contains(user)) {
        memberProfiles.add(user);

        //   if (signal.activeMembers.contains(user.id)) {
        //     activeProfiles.add(user);
        //   }
        // } else if (signal.memberRequests.contains(user.id)) {
        //   pendingProfiles.add(user);
      } else {
        unAddedProfiles.add(user);
      }
    }

    final List<Widget> viewChildren = <Widget>[
      // Available members - show all pictures
      const Text('Available'),
      UserCoinScroll(users: memberProfiles),
      spacer,

      // Active members - show all pictures
      const Text('Active'),
      UserCoinScroll(users: activeProfiles),
      spacer,
    ];

    if (unAddedProfiles.isNotEmpty) {
      // Addable users - expandable, toggle-able, profiles
      viewChildren.addAll(
        <Widget>[
          AddProfilesWindow(
            title: 'Add?',
            items: buildSwitchTiles(unAddedProfiles),
          ),
          spacer,

          // Submit button
          EzElevatedIconButton(
            onPressed: () {
              Navigator.of(context).pop();
              requestMembers(signal, requestedUsers);
            },
            icon: Icon(PlatformIcons(context).cloudUpload),
            label: 'Send requests',
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
    ezWindowNamer(context, 'Signal members');
  }

  // Return the build //

  @override
  Widget build(BuildContext context) {
    return SmokeSignalScaffold(
      title: '${signal.title} members',
      drawerHeader: const LoggedInHeader(),
      extraButtons: const <Widget>[LogoutButton()],
      body: EzScreen(StreamBuilder<List<User>>(
        stream: userStream,
        builder: (
          _,
          AsyncSnapshot<List<User>> snapshot,
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
              return sortUsers(snapshot.data!);
          }
        },
      )),
    );
  }
}
