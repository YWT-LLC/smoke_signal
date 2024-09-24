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

class CreateSignalScreen extends StatefulWidget {
  const CreateSignalScreen({super.key});

  @override
  State<CreateSignalScreen> createState() => _CreateSignalScreenState();
}

class _CreateSignalScreenState extends State<CreateSignalScreen> {
  // Gather theme data //

  static const EzSpacer spacer = EzSpacer();
  final EzSpacer padder = EzSpacer(space: EzConfig.get(paddingKey));

  late final Lang l10n = Lang.of(context)!;
  late final TextStyle? titleStyle = Theme.of(context).textTheme.titleLarge;

  // Define build data //

  late Stream<QuerySnapshot<Map<String, dynamic>>> userStream;

  bool isActive = false;
  final List<String> requestIDs = <String>[];

  late TextEditingController titleController = TextEditingController();
  late TextEditingController messageController = TextEditingController();

  /// Creates a [List] of [PlatformListTile]s for displaying [UserProfile]s alongside
  List<PlatformListTile> buildSwitches(List<UserProfile> profiles) {
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
            Text(
              profile.name,
              style: titleStyle,
              textAlign: TextAlign.start,
            ),
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
    setPageTitle('Create signal');
  }

  // Return the build //

  @override
  Widget build(BuildContext context) {
    return SmokeSignalScaffold(
      title: 'New signal',
      drawerHeader: const LoggedInHeader(),
      body: EzScreen(
        child: EzScrollView(
          children: <Widget>[
            // Title field
            ConstrainedBox(
              constraints: textFieldConstraints(context),
              child: TextFormField(
                controller: titleController,
                maxLines: 2,
                decoration: const InputDecoration(hintText: 'Signal title'),
                validator: signalTitleValidator,
                autovalidateMode: AutovalidateMode.onUnfocus,
              ),
            ),
            spacer,

            // Message field
            ConstrainedBox(
              constraints: textFieldConstraints(context),
              child: TextFormField(
                controller: messageController,
                maxLines: 1,
                decoration: const InputDecoration(hintText: 'Notification'),
                validator: signalMessageValidator,
                autovalidateMode: AutovalidateMode.onUnfocus,
              ),
            ),
            spacer,

            // Toggle for current participation
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceEvenly, // TODO: Are you sure about that?
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
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: userStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const EzImage(
                      image: signalGif,
                      semanticLabel: 'Loading',
                    );
                  case ConnectionState.done:
                  default:
                    if (snapshot.hasError) {
                      logAlert(context,
                          message: snapshot.error
                              .toString()); // TODO: await (future builder or somethin?)
                      return const SizedBox.shrink();
                    }

                    return addProfilesWindow(
                      context: context,
                      title: 'Starting members',
                      items: buildSwitches(buildProfiles(snapshot.data!.docs)),
                    );
                }
              },
            ),
            spacer,

            // Add button
            ElevatedButton.icon(
              onPressed: () async {
                closeKeyboard(context);

                // Don't do anything if the inputs are invalid
                final String title = titleController.text.trim();
                if (signalTitleValidator(title) != null) {
                  await logAlert(context, message: 'Invalid title!');
                  return;
                }

                final String message = messageController.text.trim();
                if (signalMessageValidator(message) != null) {
                  await logAlert(context, message: 'Invalid message!');
                  return;
                }

                // Attempt adding signal
                final bool added = await addToDB(
                  context: context,
                  title: title,
                  message: message,
                  isActive: isActive,
                  requestIDs: requestIDs,
                );

                if (added && context.mounted) Navigator.of(context).pop(true);
              },
              icon: Icon(PlatformIcons(context).cloudUpload),
              label: const Text('Add'),
            ),
            spacer,
          ],
        ),
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
