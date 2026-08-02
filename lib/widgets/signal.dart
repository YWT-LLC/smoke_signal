/* smoke_signal
 * Copyright (c) 2026 YWT (Empathetech LLC). All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import '../../api/export.dart';
import '../utils/export.dart';
import '../screens/export.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:open_ui/open_ui.dart';

class SignalCard extends StatefulWidget {
  final EzCP config;
  final Signal signal;
  final void Function() reloadBoard;

  /// A [Signal] made real
  const SignalCard(this.config, {super.key, required this.signal, required this.reloadBoard});

  @override
  State<SignalCard> createState() => _SignalCardState();
}

class _SignalCardState extends State<SignalCard> {
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
  late final String iconPathFitKey = '${signalID}_icon_path';

  late bool showIcon = EzCM.get(showIconKey) ?? false;

  bool active = false;

  // Define custom functions //

  /// Toggle whether the [SignalCard]s icon ([Image]) is being shown
  void toggleIcon() async {
    showIcon ? await EzCM.remove(showIconKey) : await EzCM.setBool(showIconKey, true);

    setState(() => showIcon = !showIcon);
  }

  /// Show all [SignalCard] edits the user can make
  Future<dynamic> showEdits() {
    return ezModal(
      widget.config,
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (BuildContext modalContext, StateSetter setModal) => EzScrollView(
          widget.config,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Manage members
            ElevatedButton(
              onPressed: () {
                Navigator.of(modalContext).pop();
                context.goNamed(signalMembersPath, extra: signal);
              },
              child: const Text('Members'),
            ),
            widget.config.spacer,

            // Set icon
            EzImageSetting(
              widget.config,
              pathKey: iconPathKey,
              fitKey: iconPathFitKey,
              label: 'Set icon',
            ),
            widget.config.spacer,

            // Show/hide icon
            ElevatedButton(onPressed: toggleIcon, child: const Text('Toggle icon')),
            widget.config.spacer,

            // Owner: Reset count, update message, transfer signal, or delete signal
            // Member: Leave signal
            EzCol(
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
                      widget.config.spacer,

                      // Update message
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await updateMessage(signal, title);
                        },
                        child: const Text('Update message'),
                      ),
                      widget.config.spacer,

                      // Transfer
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await transferOwnership(signal, appUser);
                        },
                        child: const Text('Transfer signal'),
                      ),
                      widget.config.spacer,

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
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Gather the contextual theme data //

    // CAW! Add this stuff to a local provider
    final double signalHeight = EzCM.get(
      widget.config.isDark ? darkSignalHeightKey : lightSignalHeightKey,
    );
    final double signalCountHeight = EzCM.get(
      widget.config.isDark ? darkSignalCountHeightKey : lightSignalCountHeightKey,
    );

    late final Color joinedColor = widget.config.colors.secondary;
    late final Color defaultColor = widget.config.colors.primary;

    final TextStyle? joinedTextStyle = widget.config.titleStyle?.copyWith(
      color: widget.config.colors.onSecondary,
    );
    final TextStyle? watchingTextStyle = widget.config.titleStyle?.copyWith(
      color: widget.config.colors.onPrimary,
    );

    // Return the build //

    final ImageProvider<Object> signalImage = ezImageProvider(
      widget.config.isDark ? darkSignalImageKey : lightSignalImageKey,
    );

    if (members.contains(appUser)) {
      return EzCol(children: <Widget>[
        // SignalCard button
        showIcon
            // With icon image
            ? GestureDetector(
                onTap: () => toggleParticipation(signal),
                onLongPress: showEdits,
                child: SizedBox(
                  width: widthOf(context),
                  height: signalHeight,
                  child: EzRow(widget.config, children: <Widget>[
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
                              style: active ? joinedTextStyle : watchingTextStyle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
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
                      child: Text(title, style: active ? joinedTextStyle : watchingTextStyle),
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
            child: EzRow(
              widget.config,
              // Check AppUser's current participation
              children: active
                  ? <Widget>[
                      // Active: show the current count surrounded by smoke signals
                      EzImage(image: signalImage, semanticLabel: 'Semantics label'),
                      Text('1', style: joinedTextStyle),
                      EzImage(image: signalImage, semanticLabel: 'Semantics label'),
                    ]
                  : <Widget>[
                      // Inactive: only show the current count
                      Text('0', style: watchingTextStyle),
                    ],
            ),
          ),
        ),
        widget.config.spacer,
      ]);

      // Current user is a prospective/requested member
    } else if (memberRequests.contains(appUser)) {
      return EzCol(children: <Widget>[
        // Label
        SizedBox(
          width: widthOf(context),
          height: signalHeight,
          child: Card(
            color: defaultColor,
            child: Center(child: Text('Join:\n$title?', style: watchingTextStyle)),
          ),
        ),
        widget.config.margin,

        // Buttons
        EzRow(widget.config, children: <Widget>[
          EzIconButton(
            widget.config,
            onPressed: doNothing,
            icon: EzIcon(widget.config, Icons.clear),
          ),
          EzIconButton(
            widget.config,
            onPressed: doNothing,
            icon: EzIcon(widget.config, Icons.check),
          ),
        ]),
      ]);
    } else {
      // Default, only reachable if signal stream is unfiltered...
      // ...and the current user is not a member
      return const SizedBox.shrink();
    }
  }
}
