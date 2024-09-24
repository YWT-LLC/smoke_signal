/* smoke_signal
 * Copyright (c) 2022-2024 Empathetech LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import '../utils/export.dart';
import '../screens/export.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empathetech_ss_api/empathetech_ss_api.dart';
import 'package:empathetech_flutter_ui/empathetech_flutter_ui.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class Signal extends StatefulWidget {
  final String owner;
  final String title;
  final String message;
  final List<String> members;
  final List<String> activeMembers;
  final List<String> memberRequests;
  final void Function() reloadBoard;

  /// Happy signaling!
  const Signal({
    super.key,
    required this.owner,
    required this.title,
    required this.message,
    required this.members,
    required this.activeMembers,
    required this.memberRequests,
    required this.reloadBoard,
  });

  /// Construct a [Signal] from a Firebase signal [DocumentSnapshot]
  static Signal buildSignal(
    DocumentSnapshot<Map<String, dynamic>> signalDoc,
    void Function() reloadBoard,
  ) {
    final Map<String, dynamic> data = signalDoc.data() as Map<String, dynamic>;

    return Signal(
      title: signalDoc.id,
      message: data[messagePath],
      members: List<String>.from(data[membersPath]),
      owner: data[ownerPath],
      activeMembers: List<String>.from(data[activeMembersPath]),
      memberRequests: List<String>.from(data[memberRequestsPath]),
      reloadBoard: reloadBoard,
    );
  }

  @override
  State<Signal> createState() => _SignalState();
}

class _SignalState extends State<Signal> {
  // Gather theme data //

  static const EzSpacer spacer = EzSpacer();
  final EzSpacer padder = EzSpacer(space: EzConfig.get(paddingKey));

  late bool showIcon = EzConfig.get(showIconKey) ?? false;

  late final EFUILang el10n = EFUILang.of(context)!;

  late final ColorScheme colorScheme = Theme.of(context).colorScheme;
  late final TextTheme textTheme = Theme.of(context).textTheme;

  late final Color joinedColor = colorScheme.secondary;
  late final Color watchingColor = colorScheme.primary;

  // Define build data //

  // Mirrors
  late final String owner = widget.owner;
  late final String title = widget.title;
  late final String message = widget.message;
  late final List<String> members = widget.members;
  late final List<String> activeMembers = widget.activeMembers;
  late final List<String> memberRequests = widget.memberRequests;
  late final void Function() reloadBoard = widget.reloadBoard;

  late final String showIconKey = '$title ShowIcon';
  late final String iconPathKey = '$title Icon';

  late final TextStyle? joinedTextStyle = textTheme.titleLarge?.copyWith(
    color: colorScheme.onSecondary,
  );

  late final TextStyle? watchingTextStyle = textTheme.titleLarge?.copyWith(
    color: colorScheme.onPrimary,
  );

  // Define custom functions //

  /// Toggle whether the [Signal]s icon ([Image]) is being shown
  void toggleIcon() async {
    showIcon
        ? await EzConfig.remove(showIconKey)
        : await EzConfig.setBool(showIconKey, true);

    setState(() {});
  }

  /// Show all [Signal] edits the user can make
  Future<dynamic> showEdits() {
    return showPlatformDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return EzAlertDialog(
          title: Text(el10n.gOptions, textAlign: TextAlign.center),
          contents: <Widget>[
            // Manage members
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.goNamed(
                  signalMembersPath,
                  extra: Signal(
                    owner: widget.owner,
                    title: title,
                    message: message,
                    members: members,
                    activeMembers: activeMembers,
                    memberRequests: memberRequests,
                    reloadBoard: reloadBoard,
                  ),
                );
              },
              child: const Text('Members'),
            ),
            spacer,

            // Set icon
            EzImageSetting(
              configKey: iconPathKey,
              label: 'Set icon',
              updateThemeOption: false,
            ),
            spacer,

            // Show/hide icon
            ElevatedButton(
              onPressed: toggleIcon,
              child: const Text('Toggle icon'),
            ),
            spacer,

            // Owner: Reset count, update message, transfer signal, or delete signal
            // Member: Leave signal
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment
                  .spaceEvenly, // TODO: Are you sure about that?
              children: AppUser.account.uid == widget.owner
                  ? <Widget>[
                      // Reset
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).pop(true);
                          await resetSignal(context, title);
                        },
                        child: const Text('Reset signal'),
                      ),
                      spacer,

                      // Update message
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          updateMessage(context, title);
                        },
                        child: const Text('Update message'),
                      ),
                      spacer,

                      // Transfer
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          confirmTransfer(
                            context: context,
                            title: title,
                            members: members,
                          );
                        },
                        child: const Text('Transfer signal'),
                      ),
                      spacer,

                      // Delete
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await confirmDelete(
                            context: context,
                            title: title,
                            prefKeys: <String>{showIconKey, iconPathKey},
                          );
                        },
                        child: const Text('Delete signal'),
                      ),
                    ]
                  : <Widget>[
                      // Leave
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          confirmDeparture(
                            context: context,
                            title: title,
                            prefKeys: <String>{showIconKey, iconPathKey},
                          );
                        },
                        child: const Text('Leave signal'),
                      ),
                    ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (members.contains(AppUser.account.uid)) {
      // Current user is a member
      final bool active = activeMembers.contains(AppUser.account.uid);

      return Column(
        children: <Widget>[
          // Signal button
          showIcon
              // With icon image
              ? GestureDetector(
                  onTap: () => toggleParticipation(
                    context: context,
                    active: active,
                    title: title,
                    memberIDs: members,
                    message: message,
                  ),
                  onLongPress: showEdits,
                  child: SizedBox(
                    width: widthOf(context),
                    height: signalHeight,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment
                          .spaceEvenly, // TODO: Are you sure about that?
                      children: <Widget>[
                        // Icon image
                        SizedBox(
                          width: signalHeight,
                          height: signalHeight,
                          child: EzImage(
                            image: provideImage(iconPathKey),
                            semanticLabel: 'Semantics label',
                          ),
                        ),

                        // Title card
                        Expanded(
                          child: SizedBox.expand(
                            child: Card(
                              color: active ? joinedColor : watchingColor,
                              child: Center(
                                child: Text(
                                  title,
                                  style: active
                                      ? joinedTextStyle
                                      : watchingTextStyle,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: () => toggleParticipation(
                    context: context,
                    active: active,
                    title: title,
                    memberIDs: members,
                    message: message,
                  ),
                  onLongPress: showEdits,
                  child: SizedBox(
                    width: widthOf(context),
                    height: signalHeight,
                    child: Card(
                      color: active ? joinedColor : watchingColor,
                      child: Center(
                        child: Text(
                          title,
                          style: active ? joinedTextStyle : watchingTextStyle,
                        ),
                      ),
                    ),
                  ),
                ),

          // Signal count
          SizedBox(
            width: widthOf(context) * (2 / 3),
            height: signalCountHeight,
            child: Card(
              color: activeMembers.contains(AppUser.account.uid)
                  ? joinedColor
                  : watchingColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceEvenly, // TODO: Are you sure about that?

                // Check AppUser's current participation
                children: activeMembers.contains(AppUser.account.uid)
                    ? <Widget>[
                        // Active: show the current count surrounded by smoke signals
                        EzImage(
                          image: provideImage(signalImageKey),
                          semanticLabel: 'Semantics label',
                        ),
                        Text(
                          activeMembers.length.toString(),
                          style: joinedTextStyle,
                        ),
                        EzImage(
                          image: provideImage(signalImageKey),
                          semanticLabel: 'Semantics label',
                        ),
                      ]
                    : <Widget>[
                        // Inactive: only show the current count
                        Text(
                          activeMembers.length.toString(),
                          style: watchingTextStyle,
                        ),
                      ],
              ),
            ),
          ),
          spacer,
        ],
      );

      // Current user is a prospective/requested member
    } else if (memberRequests.contains(AppUser.account.uid)) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment:
            MainAxisAlignment.spaceEvenly, // TODO: Are you sure about that?
        children: <Widget>[
          // Label
          SizedBox(
            width: widthOf(context),
            height: signalHeight,
            child: Card(
              color: watchingColor,
              child: Center(
                child: Text(
                  'Join:\n$title?',
                  style: watchingTextStyle,
                ),
              ),
            ),
          ),
          padder,

          // Buttons
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceEvenly, // TODO: Are you sure about that?
            children: <Widget>[
              ElevatedButton(
                onPressed: () => declineInvite(context, title),
                child: Icon(PlatformIcons(context).clear),
              ),
              ElevatedButton(
                onPressed: () => acceptInvite(context, title),
                child: Icon(PlatformIcons(context).checkMark),
              ),
            ],
          ),
        ],
      );
    } else {
      // Default, only reachable if signal stream is unfiltered...
      // ...and the current user is not a member
      return const SizedBox.shrink();
    }
  }
}
