/* smoke_signal
 * Copyright (c) 2025 Empathetech LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import '../export.dart';

const String titleKey = 'title';
const String descriptionKey = 'description';
const String messageKey = 'message';

const String ownerKey = 'owner';
const String membersKey = 'members';

/// JSON-serializable configuration for a [Signal]
class Signal {
  final String? id;
  final String title;
  final String description;
  final String message;

  final User owner;
  final List<User> members;

  Signal({
    this.id,
    required this.title,
    required this.description,
    required this.message,
    required this.owner,
    required this.members,
  });

  factory Signal.fromJson(Map<String, dynamic> json) => Signal(
        id: json[idKey] as String?,
        title: json[titleKey] as String,
        description: json[descriptionKey] as String,
        message: json[messageKey] as String,
        owner: User.fromJson(json[ownerKey]),
        members: (json[membersKey] as List<dynamic>)
            .map((dynamic m) => User.fromJson(m as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        idKey: id,
        titleKey: title,
        descriptionKey: description,
        messageKey: message,
        ownerKey: owner,
        membersKey: members,
      };

  @override
  String toString() => '''{
  id: $id,
  title: $title,
  description: $description,
  message: $message,
  owner: $owner,
  members: $members
}''';
}
