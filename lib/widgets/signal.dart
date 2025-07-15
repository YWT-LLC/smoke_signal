/* smoke_signal
 * Copyright (c) 2025 Empathetech LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import '../../api/export.dart';
import '../utils/export.dart';
import '../screens/export.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
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

  final double signalHeight = EzConfig.get(signalHeightKey);
  final double signalCountHeight = EzConfig.get(signalCountHeightKey);

  late final ColorScheme colorScheme = Theme.of(context).colorScheme;
  late final Color joinedColor = colorScheme.secondary;
  late final Color defaultColor = colorScheme.primary;

  late final TextTheme textTheme = Theme.of(context).textTheme;

  late final EFUILang el10n = EFUILang.of(context)!;

  // Define build data //

  late final AppUser appUser = Provider.of<AppUserProvider>(context).value!;

  late final Signal signal = widget.signal;
  late final String? signalID = signal.id;
  late final User owner = signal.owner;
  late final String title = signal.title;
  late final String message = signal.message;
  late final List<User> members = signal.members;
  late final List<User> memberRequests = <User>[];

  late final String showIconKey = '${signalID}_show_icon';
  late final String iconPathKey = '${signalID}_icon_path';

  late bool showIcon = EzConfig.get(showIconKey) ?? false;

  late final TextStyle? joinedTextStyle = textTheme.titleLarge?.copyWith(
    color: colorScheme.onSecondary,
  );

  late final TextStyle? watchingTextStyle = textTheme.titleLarge?.copyWith(
    color: colorScheme.onPrimary,
  );

  bool active = false;

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
                  extra: signal,
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
              children: appUser.uid == owner.uid
                  ? <Widget>[
                      // Reset
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).pop(true);
                          await resetSignal(signal);
                        },
                        child: const Text('Reset signal'),
                      ),
                      spacer,

                      // Update message
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await updateMessage(signal, title);
                        },
                        child: const Text('Update message'),
                      ),
                      spacer,

                      // Transfer
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await transferOwnership(signal, appUser);
                        },
                        child: const Text('Transfer signal'),
                      ),
                      spacer,

                      // Delete
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await deleteSignal(signal);
                        },
                        child: const Text('Delete signal'),
                      ),
                    ]
                  : <Widget>[
                      // Leave
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          leaveSignal(signal);
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
    if (members.contains(appUser)) {
      return Column(
        children: <Widget>[
          // SignalCard button
          showIcon
              // With icon image
              ? GestureDetector(
                  onTap: () => toggleParticipation(signal),
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
                  onTap: () => toggleParticipation(signal),
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
              color: active ? joinedColor : defaultColor,
              child: Row(
                // Check AppUser's current participation
                children: active
                    ? <Widget>[
                        // Active: show the current count surrounded by smoke signals
                        EzImage(
                          image: ezImageProvider(signalImageKey),
                          semanticLabel: 'Semantics label',
                        ),
                        Text(
                          '1',
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
                          '0',
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
    } else if (memberRequests.contains(appUser)) {
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
