/* smoke_signal
 * Copyright (c) 2022-2025 Empathetech LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import '../utils/export.dart';
import '../screens/export.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:empathetech_ss_api/empathetech_ss_api.dart';
import 'package:empathetech_flutter_ui/empathetech_flutter_ui.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class SignalCard extends StatefulWidget {
  /// [Signal] to visualize
  final Signal signal;

  /// If this signal is in a [SignalBoard], what should happen on reload?
  final void Function() reloadBoard;

  /// A [Signal] made real
  const SignalCard({
    super.key,
    required this.signal,
    required this.reloadBoard,
  });

  @override
  State<SignalCard> createState() => _SignalCardState();
}

class _SignalCardState extends State<SignalCard> {
  // Gather theme data //

  static const EzSpacer spacer = EzSpacer();

  late final ColorScheme colorScheme = Theme.of(context).colorScheme;
  late final Color joinedColor = colorScheme.secondary;
  late final Color defaultColor = colorScheme.primary;

  late final TextTheme textTheme = Theme.of(context).textTheme;

  late final EFUILang el10n = EFUILang.of(context)!;

  // Define build data //

  // Aliases
  late final String? signalID = widget.signal.id;
  late final User owner = widget.signal.owner;
  late final String title = widget.signal.title;
  late final String message = widget.signal.message;
  late final List<User> members = widget.signal.members;

  late final String showIconKey = '${signalID}_show_icon';
  late final String iconPathKey = '${signalID}_icon_path';

  late bool showIcon = EzConfig.get(showIconKey) ?? false;

  late final TextStyle? joinedTextStyle = textTheme.titleLarge?.copyWith(
    color: colorScheme.onSecondary,
  );

  late final TextStyle? watchingTextStyle = textTheme.titleLarge?.copyWith(
    color: colorScheme.onPrimary,
  );

  // Define custom functions //

  /// Toggle whether the [SignalCard]s icon ([Image]) is being shown
  void toggleIcon() async {
    showIcon
        ? await EzConfig.remove(showIconKey)
        : await EzConfig.setBool(showIconKey, true);

    setState(() => showIcon = !showIcon);
  }

  /// Show all [SignalCard] edits the user can make
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
                  extra: widget.signal,
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
              children: AppUser.uid == owner
                  ? <Widget>[
                      // Reset
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).pop(true);
                          await resetSignal(widget.signal);
                        },
                        child: const Text('Reset signal'),
                      ),
                      spacer,

                      // Update message
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await updateMessage(widget.signal, title);
                        },
                        child: const Text('Update message'),
                      ),
                      spacer,

                      // Transfer
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await transferOwnership(widget.signal, AppUser);
                        },
                        child: const Text('Transfer signal'),
                      ),
                      spacer,

                      // Delete
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await deleteSignal(widget.signal);
                        },
                        child: const Text('Delete signal'),
                      ),
                    ]
                  : <Widget>[
                      // Leave
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          leaveSignal(widget.signal);
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
    if (members.contains()) {
      // Current user is a member
      final bool active = activeMembers.contains(AppUser.account.uid);

      return Column(
        children: <Widget>[
          // SignalCard button
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
                      children: <Widget>[
                        // Icon image
                        SizedBox(
                          width: signalHeight,
                          height: signalHeight,
                          child: EzImage(
                            image: ezImageProvider(iconPathKey),
                            semanticLabel: 'Semantics label',
                          ),
                        ),

                        // Title card
                        Expanded(
                          child: SizedBox.expand(
                            child: Card(
                              color: active ? joinedColor : defaultColor,
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
                      color: active ? joinedColor : defaultColor,
                      child: Center(
                        child: Text(
                          title,
                          style: active ? joinedTextStyle : watchingTextStyle,
                        ),
                      ),
                    ),
                  ),
                ),

          // SignalCard count
          SizedBox(
            width: widthOf(context) * (2 / 3),
            height: signalCountHeight,
            child: Card(
              color: activeMembers.contains(AppUser.account.uid)
                  ? joinedColor
                  : defaultColor,
              child: Row(
                // Check AppUser's current participation
                children: activeMembers.contains(AppUser.account.uid)
                    ? <Widget>[
                        // Active: show the current count surrounded by smoke signals
                        EzImage(
                          image: ezImageProvider(signalImageKey),
                          semanticLabel: 'Semantics label',
                        ),
                        Text(
                          activeMembers.length.toString(),
                          style: joinedTextStyle,
                        ),
                        EzImage(
                          image: ezImageProvider(signalImageKey),
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
        children: <Widget>[
          // Label
          SizedBox(
            width: widthOf(context),
            height: signalHeight,
            child: Card(
              color: defaultColor,
              child: Center(
                child: Text(
                  'Join:\n$title?',
                  style: watchingTextStyle,
                ),
              ),
            ),
          ),
          EzSpacer(space: EzConfig.get(marginKey)),

          // Buttons
          Row(
            children: <Widget>[
              ElevatedButton(
                onPressed: doNothing,
                child: Icon(PlatformIcons(context).clear),
              ),
              ElevatedButton(
                onPressed: doNothing,
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
