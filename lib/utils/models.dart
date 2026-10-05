/* smoke_signal
 * Copyright (c) 2026 YWT (Empathetech LLC). All rights reserved.
 * See LICENSE for distribution and usage details.
 */

// For people //

class User {
  final String id;
  final DateTime createdAt;
  final String username;
  final String displayName;
  final String? thumbnailUrl;

  const User({
    required this.id,
    required this.createdAt,
    required this.username,
    required this.displayName,
    this.thumbnailUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as String,
        createdAt: DateTime.parse(json['created_at'] as String),
        username: json['username'] as String,
        displayName: json['display_name'] as String,
        thumbnailUrl: json['thumbnail_url'] as String?,
      );
}

// For messaging //

class Attachment {
  final String filename;
  final String url;
  final String id;
  final String kind;
  final String mime;
  final int size;

  const Attachment({
    required this.filename,
    required this.url,
    required this.id,
    required this.kind,
    required this.mime,
    required this.size,
  });

  bool get isImage => kind == 'image';
  bool get isAudio => kind == 'audio';
  bool get isVideo => kind == 'video';

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
        filename: json['filename'] as String,
        url: json['url'] as String,
        id: json['id'] as String,
        kind: json['kind'] as String,
        mime: json['mime'] as String,
        size: (json['size'] as num).toInt(),
      );
}

class Message {
  final String id;
  final String conversationId;
  final DateTime createdAt;
  final User? sender;
  final String content;
  final List<Attachment> attachments;

  const Message({
    required this.id,
    required this.conversationId,
    required this.createdAt,
    required this.sender,
    required this.content,
    required this.attachments,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json['id'] as String,
        conversationId: json['conversation_id'] as String,
        createdAt: DateTime.parse(json['created_at'] as String),
        sender:
            json['sender'] == null ? null : User.fromJson(json['sender'] as Map<String, dynamic>),
        content: json['content'] as String,
        attachments: (json['attachments'] as List<dynamic>)
            .map((dynamic a) => Attachment.fromJson(a as Map<String, dynamic>))
            .toList(),
      );
}

class Conversation {
  final String id;
  final String type;
  final DateTime createdAt;
  final String name;
  final List<User> members;
  final DateTime? lastMessageAt;

  const Conversation({
    required this.id,
    required this.type,
    required this.createdAt,
    required this.name,
    required this.members,
    this.lastMessageAt,
  });

  bool get isBonfire => type == 'bonfire';
  bool get isDm => type == 'dm';
  bool get isGroup => type == 'group';

  String titleFor(String myUserId) {
    if (isDm) {
      final Iterable<User> others = members.where((User m) => m.id != myUserId);
      return others.isEmpty ? 'Deleted user' : others.first.displayName;
    }
    return name;
  }

  factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
        id: json['id'] as String,
        type: json['type'] as String,
        createdAt: DateTime.parse(json['created_at'] as String),
        name: (json['name'] as String?) ?? '',
        members: ((json['members'] as List<dynamic>?) ?? const <dynamic>[])
            .map((dynamic u) => User.fromJson(u as Map<String, dynamic>))
            .toList(),
        lastMessageAt: json['last_message_at'] == null
            ? null
            : DateTime.parse(json['last_message_at'] as String),
      );
}

//* Events *//

sealed class ServerEvent {
  const ServerEvent();

  factory ServerEvent.fromJson(Map<String, dynamic> json) => switch (json['type']) {
        // New message
        'message.new' => NewMessageEvent(Message.fromJson(json['message'] as Map<String, dynamic>)),

        // Convo upsert
        'conversation.upsert' => ConversationUpsertEvent(Conversation.fromJson(
            json['conversation'] as Map<String, dynamic>,
          )),

        // Error
        'error' => ServerErrorEvent((json['error'] as String?) ?? 'Unknown error'),

        // Default
        _ => ServerErrorEvent('Unknown event: ${json['type']}'),
      };
}

class ServerErrorEvent extends ServerEvent {
  final String message;

  const ServerErrorEvent(this.message);
}

class NewMessageEvent extends ServerEvent {
  final Message message;

  const NewMessageEvent(this.message);
}

class ConversationUpsertEvent extends ServerEvent {
  final Conversation conversation;

  const ConversationUpsertEvent(this.conversation);
}
