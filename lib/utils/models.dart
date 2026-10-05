/* smoke_signal
 * Copyright (c) 2026 YWT (Empathetech LLC). All rights reserved.
 * See LICENSE for distribution and usage details.
 */

class User {
  const User({
    required this.id,
    required this.username,
    required this.displayName,
    this.thumbnailUrl,
    required this.createdAt,
  });

  final String id;
  final String username;
  final String displayName;
  final String? thumbnailUrl; // relative; resolve with ApiClient.resolve()
  final DateTime createdAt;

  factory User.fromJson(Map<String, dynamic> j) => User(
        id: j['id'] as String,
        username: j['username'] as String,
        displayName: j['display_name'] as String,
        thumbnailUrl: j['thumbnail_url'] as String?,
        createdAt: DateTime.parse(j['created_at'] as String),
      );
}

class Attachment {
  const Attachment({
    required this.id,
    required this.kind,
    required this.mime,
    required this.size,
    required this.filename,
    required this.url,
  });

  final String id;
  final String kind; // image | audio | video  (GIFs are "image")
  final String mime;
  final int size;
  final String filename;
  final String url; // relative

  bool get isImage => kind == 'image';
  bool get isAudio => kind == 'audio';
  bool get isVideo => kind == 'video';

  factory Attachment.fromJson(Map<String, dynamic> j) => Attachment(
        id: j['id'] as String,
        kind: j['kind'] as String,
        mime: j['mime'] as String,
        size: (j['size'] as num).toInt(),
        filename: j['filename'] as String,
        url: j['url'] as String,
      );
}

class Message {
  const Message({
    required this.id,
    required this.conversationId,
    required this.sender,
    required this.content,
    required this.attachments,
    required this.createdAt,
  });

  final String id;
  final String conversationId;
  final User? sender; // null = deleted account
  final String content;
  final List<Attachment> attachments;
  final DateTime createdAt;

  factory Message.fromJson(Map<String, dynamic> j) => Message(
        id: j['id'] as String,
        conversationId: j['conversation_id'] as String,
        sender: j['sender'] == null ? null : User.fromJson(j['sender'] as Map<String, dynamic>),
        content: j['content'] as String,
        attachments: (j['attachments'] as List)
            .map((a) => Attachment.fromJson(a as Map<String, dynamic>))
            .toList(),
        createdAt: DateTime.parse(j['created_at'] as String),
      );
}

class Conversation {
  const Conversation({
    required this.id,
    required this.type,
    required this.name,
    required this.members,
    required this.createdAt,
    this.lastMessageAt,
  });

  final String id;
  final String type; // bonfire | dm | group
  final String name;
  final List<User> members; // empty for bonfires
  final DateTime createdAt;
  final DateTime? lastMessageAt;

  bool get isBonfire => type == 'bonfire';
  bool get isDm => type == 'dm';
  bool get isGroup => type == 'group';

  String titleFor(String myUserId) {
    if (isDm) {
      final others = members.where((m) => m.id != myUserId);
      return others.isEmpty ? 'Deleted user' : others.first.displayName;
    }
    return name;
  }

  factory Conversation.fromJson(Map<String, dynamic> j) => Conversation(
        id: j['id'] as String,
        type: j['type'] as String,
        name: (j['name'] as String?) ?? '',
        members: ((j['members'] as List?) ?? const [])
            .map((u) => User.fromJson(u as Map<String, dynamic>))
            .toList(),
        createdAt: DateTime.parse(j['created_at'] as String),
        lastMessageAt:
            j['last_message_at'] == null ? null : DateTime.parse(j['last_message_at'] as String),
      );
}

sealed class ServerEvent {
  const ServerEvent();

  factory ServerEvent.fromJson(Map<String, dynamic> j) => switch (j['type']) {
        'message.new' => NewMessageEvent(Message.fromJson(j['message'] as Map<String, dynamic>)),
        'conversation.upsert' =>
          ConversationUpsertEvent(Conversation.fromJson(j['conversation'] as Map<String, dynamic>)),
        'error' => ServerErrorEvent((j['error'] as String?) ?? 'Unknown error'),
        _ => ServerErrorEvent('Unknown event: ${j['type']}'),
      };
}

class NewMessageEvent extends ServerEvent {
  const NewMessageEvent(this.message);
  final Message message;
}

/// Sent when a DM/group is created or its membership changes. Insert or replace by id.
class ConversationUpsertEvent extends ServerEvent {
  const ConversationUpsertEvent(this.conversation);
  final Conversation conversation;
}

class ServerErrorEvent extends ServerEvent {
  const ServerErrorEvent(this.message);
  final String message;
}
