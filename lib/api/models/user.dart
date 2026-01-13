/* smoke_signal
 * Copyright (c) 2026 Empathetech LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import '../export.dart';

const String emailKey = 'email';
const String displayNameKey = 'displayName';
const String avatarUrlKey = 'avatarURL';

/// JSON-serializable configuration for a [User]
class User {
  final String uid;
  final String email;
  final String displayName;
  final String? avatarURL;

  /// A Smoke Signaler
  User({
    required this.uid,
    required this.email,
    required this.displayName,
    this.avatarURL,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        uid: json[uidKey] as String,
        email: json[emailKey] as String,
        displayName: json[displayNameKey] as String,
        avatarURL: json[avatarUrlKey] as String?,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        uidKey: uid,
        emailKey: email,
        displayNameKey: displayName,
        avatarUrlKey: avatarURL,
      };

  @override
  String toString() => '''{
  uid: $uid,
  email: $email,
  displayName: $displayName,
  avatarURL: $avatarURL
}''';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! User) return false;
    return uid == other.uid;
  }

  @override
  int get hashCode => uid.hashCode;
}

const String authTokenKey = 'authToken';

/// JSON-serializable configuration for an [AppUser]
class AppUser extends User {
  final String? authToken;

  /// [User] that's running the app
  AppUser({
    required super.uid,
    this.authToken,
    required super.email,
    required super.displayName,
    super.avatarURL,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        uid: json[uidKey] as String,
        authToken: json[authTokenKey] as String?,
        email: json[emailKey] as String,
        displayName: json[displayNameKey] as String,
        avatarURL: json[avatarUrlKey] as String?,
      );

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        uidKey: uid,
        authTokenKey: authToken,
        emailKey: email,
        displayNameKey: displayName,
        avatarUrlKey: avatarURL,
      };

  @override
  String toString() => '''{
  uid: $uid,
  authToken: $authToken
  email: $email,
  displayName: $displayName,
  avatarURL: $avatarURL,
}''';
}
