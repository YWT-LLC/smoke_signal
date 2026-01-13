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

class CreateSignalScreen extends StatefulWidget {
  const CreateSignalScreen({super.key});

  @override
  State<CreateSignalScreen> createState() => _CreateSignalScreenState();
}

class _CreateSignalScreenState extends State<CreateSignalScreen> {
  // Gather theme data //

  static const EzSpacer spacer = EzSpacer();

  final double margin = EzConfig.get(marginKey);
  final double spacing = EzConfig.get(spacingKey);
  final double iconSize = EzConfig.get(iconSizeKey);

  late final Lang l10n = Lang.of(context)!;
  late final TextStyle? titleStyle = Theme.of(context).textTheme.titleLarge;

  // Define build data //

  late final AppUser appUser = Provider.of<AppUserProvider>(context).value!;

  Stream<User>? userStream;

  bool isActive = false;
  final List<String> requestIDs = <String>[];

  late TextEditingController titleController = TextEditingController();
  late TextEditingController messageController = TextEditingController();

  /// Creates a [List] of [PlatformListTile]s for displaying [UserProfile]s alongside
  List<PlatformListTile> buildSwitches(List<User> users) {
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
            Text(
              user.displayName,
              style: titleStyle,
              textAlign: TextAlign.start,
            ),
          ],
        ),

        // Toggle
        trailing: Checkbox(
          value: requestIDs.contains(user.uid),
          onChanged: (bool? value) {
            if (value == true) {
              setState(() => requestIDs.add(user.uid));
            } else {
              setState(() => requestIDs.remove(user.uid));
            }
          },
        ),
      );
    }).toList();
  }

  // Init //

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  void getUsers() async {
    if (userStream == null) {
      final dynamic results = await streamUsers();

      switch (results.runtimeType) {
        case const (Stream<User>):
          userStream = results as Stream<User>;
          break;
        case const (String):
          if (mounted) {
            await ezLogAlert(context, message: results as String);
          }
          break;
        default:
          await ezLogAlert(context, message: 'Unknown error');
          break;
      }
    }
  }

  // Set the page title //

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ezWindowNamer(context, 'Create signal');
  }

  // Return the build //

  @override
  Widget build(BuildContext context) {
    return SmokeSignalScaffold(
      title: 'New signal',
      drawerHeader: const LoggedInHeader(),
      extraButtons: const <Widget>[LogoutButton()],
      body: EzScreen(EzScrollView(children: <Widget>[
        if (spacing > margin) EzSpacer(space: spacing - margin),

        // Title field
        ConstrainedBox(
          constraints: ezTextFieldConstraints(context),
          child: TextFormField(
            controller: titleController,
            maxLines: 2,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(hintText: 'Signal title'),
            validator: validateSignalTitle,
            autovalidateMode: AutovalidateMode.onUnfocus,
          ),
        ),
        spacer,

        // Message field
        ConstrainedBox(
          constraints: ezTextFieldConstraints(context),
          child: TextFormField(
            controller: messageController,
            maxLines: 1,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(hintText: 'Notification'),
            validator: validateSignalMessage,
            autovalidateMode: AutovalidateMode.onUnfocus,
          ),
        ),
        spacer,

        // Toggle for current participation
        Row(
          children: <Widget>[
            Text('Currently active?', style: titleStyle),
            Checkbox(
              value: isActive,
              onChanged: (bool? value) {
                closeKeyboard(context);
                setState(() => isActive = value!);
              },
            ),
          ],
        ),
        spacer,

        // List of toggle-able members to send join requests on creation
        StreamBuilder<User>(
          stream: userStream,
          builder: (_, AsyncSnapshot<User> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const EzImage(
                  image: signalGif,
                  semanticLabel: 'Loading',
                );
              case ConnectionState.done:
              default:
                if (snapshot.hasError) {
                  ezLogAlert(context, message: snapshot.error.toString());
                  return const SizedBox.shrink();
                }

                return const AddProfilesWindow(
                  title: 'Starting members',
                  items: <PlatformListTile>[],
                );
            }
          },
        ),
        spacer,

        // Add button
        EzElevatedIconButton(
          onPressed: () async {
            closeKeyboard(context);

            // Don't do anything if the inputs are invalid
            final String title = titleController.text.trim();
            if (validateSignalTitle(title) != null) {
              await ezLogAlert(context, message: 'Invalid title!');
              return;
            }

            final String message = messageController.text.trim();
            if (validateSignalMessage(message) != null) {
              await ezLogAlert(context, message: 'Invalid message!');
              return;
            }

            // Attempt adding signal
            final String? added = await addToDB(Signal(
              title: title,
              description: '',
              message: message,
              owner: appUser,
              members: <User>[appUser],
            ));

            if (added == null) {
              if (context.mounted) Navigator.of(context).pop(true);
            } else {
              if (context.mounted) {
                Navigator.of(context).pop(true);
                await ezLogAlert(context, message: 'Invalid title!');
              }
            }
          },
          icon: Icon(PlatformIcons(context).cloudUpload),
          label: 'Add',
        ),
        spacer,
      ])),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    messageController.dispose();
    super.dispose();
  }
}
