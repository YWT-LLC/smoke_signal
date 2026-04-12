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

class SignalMembersScreen extends StatefulWidget {
  final Signal signal;

  SignalMembersScreen(this.signal) : super(key: ValueKey<int>(EzConfig.seed));

  @override
  State<SignalMembersScreen> createState() => _SignalMembersScreenState();
}

class _SignalMembersScreenState extends State<SignalMembersScreen> {
  // Define the build data //

  late final AppUser appUser = Provider.of<AppUserProvider>(context).value!;

  late Stream<List<User>> userStream;

  late final Signal signal = widget.signal;
  final List<User> requestedUsers = <User>[];

  // Define custom widgets //

  // Creates the widgets for the toggle list from the gathered profiles
  List<ListTile> buildSwitchTiles(List<User> users) {
    final List<User> copy = List<User>.from(users);
    copy.removeWhere((User user) => user == appUser);

    return copy.map((User user) {
      return ListTile(
        // User info
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Profile image/avatar
            CircleAvatar(
              foregroundImage: user.avatarURL != null
                  ? CachedNetworkImageProvider(user.avatarURL!)
                  : null,
              minRadius: EzConfig.iconSize,
              maxRadius: EzConfig.iconSize,
            ),
            EzMargin(),

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
      EzConfig.spacer,

      // Active members - show all pictures
      const Text('Active'),
      UserCoinScroll(users: activeProfiles),
      EzConfig.spacer,
    ];

    if (unAddedProfiles.isNotEmpty) {
      // Addable users - expandable, toggle-able, profiles
      viewChildren.addAll(
        <Widget>[
          AddProfilesWindow(
            title: 'Add?',
            items: buildSwitchTiles(unAddedProfiles),
          ),
          EzConfig.spacer,

          // Submit button
          EzElevatedIconButton(
            onPressed: () {
              Navigator.of(context).pop();
              requestMembers(signal, requestedUsers);
            },
            icon: const Icon(Icons.cloud_upload),
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
    ezWindowNamer('Signal members');
    userStream = streamUsers();
  }

  // Return the build //

  @override
  Widget build(BuildContext context) {
    return SmokeSignalScaffold(
      EzScreen(StreamBuilder<List<User>>(
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
      title: '${signal.title} members',
      drawerHeader: const LoggedInHeader(),
      extraButtons: const <Widget>[LogoutButton()],
    );
  }
}
