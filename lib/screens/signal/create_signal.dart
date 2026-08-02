/* smoke_signal
 * Copyright (c) 2026 YWT (Empathetech LLC). All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import '../../api/export.dart';
import '../../utils/export.dart';
import '../../widgets/export.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:open_ui/open_ui.dart';

class CreateSignalScreen extends StatefulWidget {
  const CreateSignalScreen({super.key});

  @override
  State<CreateSignalScreen> createState() => _CreateSignalScreenState();
}

class _CreateSignalScreenState extends State<CreateSignalScreen> {
  // Define the build data //

  late final AppUser appUser = Provider.of<AppUserProvider>(context).value!;

  Stream<User>? userStream;

  bool isActive = false;
  final List<String> requestIDs = <String>[];

  late TextEditingController titleController = TextEditingController();
  late TextEditingController messageController = TextEditingController();

  List<ListTile> buildSwitches(EzCP config, List<User> users, TextStyle? titleStyle) {
    final List<User> copy = List<User>.from(users);
    copy.removeWhere((User user) => user == appUser);

    return copy.map((User user) {
      return ListTile(
        // User info
        title: EzRow(
          config,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Profile image/avatar
            CircleAvatar(
              foregroundImage:
                  user.avatarURL != null ? CachedNetworkImageProvider(user.avatarURL!) : null,
              minRadius: config.iconSize,
              maxRadius: config.iconSize,
            ),
            config.margin,

            // Display name
            Text(user.displayName, style: titleStyle, textAlign: TextAlign.start),
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
    ezWindowNamer('Create signal');
    getUsers();
  }

  void getUsers() async {
    final EzCP config = configWatcher(context);

    if (userStream == null) {
      final dynamic results = await streamUsers();

      switch (results.runtimeType) {
        case const (Stream<User>):
          userStream = results as Stream<User>;
          break;

        case const (String):
          if (mounted) await ezLogAlert(config, context: context, message: results as String);
          break;

        default:
          if (mounted) await ezLogAlert(config, context: context, message: 'Unknown error');
          break;
      }
    }
  }

  // Return the build //

  @override
  Widget build(BuildContext context) {
    return Consumer<EzCP>(
      builder: (_, EzCP config, __) => SmokeSignalScaffold(
        config,
        body: EzScreen(
          config,
          child: EzScrollView(
            config,
            children: <Widget>[
              EzHeader(config),

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
              config.spacer,

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
              config.spacer,

              // Toggle for current participation
              EzRow(config, children: <Widget>[
                Text('Currently active?', style: config.titleStyle),
                Checkbox(
                  value: isActive,
                  onChanged: (bool? value) {
                    closeKeyboard(context);
                    setState(() => isActive = value!);
                  },
                ),
              ]),
              config.spacer,

              // List of toggle-able members to send join requests on creation
              StreamBuilder<User>(
                stream: userStream,
                builder: (_, AsyncSnapshot<User> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const EzImage(image: signalGif, semanticLabel: 'Loading');
                    case ConnectionState.done:
                    default:
                      if (snapshot.hasError) {
                        ezLogAlert(config, context: context, message: snapshot.error.toString());
                        return const SizedBox.shrink();
                      }

                      return AddProfilesWindow(
                        config,
                        title: 'Starting members',
                        items: <ListTile>[],
                      );
                  }
                },
              ),
              config.spacer,

              // Add button
              EzElevatedIconButton(
                config,
                onPressed: () async {
                  closeKeyboard(context);

                  // Don't do anything if the inputs are invalid
                  final String title = titleController.text.trim();
                  if (validateSignalTitle(title) != null) {
                    await ezLogAlert(config, context: context, message: 'Invalid title!');
                    return;
                  }

                  final String message = messageController.text.trim();
                  if (validateSignalMessage(message) != null) {
                    await ezLogAlert(config, context: context, message: 'Invalid message!');
                    return;
                  }

                  // Attempt adding signal
                  final String? added = await addToDB(
                    Signal(
                      title: title,
                      description: '',
                      message: message,
                      owner: appUser,
                      members: <User>[appUser],
                    ),
                  );

                  if (added == null) {
                    if (context.mounted) Navigator.of(context).pop(true);
                  } else {
                    if (context.mounted) {
                      Navigator.of(context).pop(true);
                      await ezLogAlert(config, context: context, message: 'Invalid title!');
                    }
                  }
                },
                icon: const Icon(Icons.cloud_upload),
                label: 'Add',
              ),
              config.spacer,
            ],
          ),
        ),
        title: 'New signal',
        drawerHeader: LoggedInHeader(config),
        extraButtons: <Widget>[LogoutButton(config)],
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    messageController.dispose();
    super.dispose();
  }
}
