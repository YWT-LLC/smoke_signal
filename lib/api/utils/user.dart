/* smoke_signal
 * Copyright (c) 2025 Empathetech LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import '../export.dart';

import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:empathetech_flutter_ui/empathetech_flutter_ui.dart';

// Me //

/// Attempt user creation
/// TODO: Attempt login if username is found
Future<dynamic> signUp({
  required String email,
  required String password,
}) async {
  try {
    final Response response = await post(
      Uri.parse('https://your-activitypub-server.com/api/signUp'), // TODO
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
      headers: <String, String>{'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      return AppUser.fromJson(jsonDecode(response.body));
    } else {
      return 'Failure: ${response.body}';
    }
  } catch (e) {
    return 'Error: ${e.toString()}';
  }
}

/// Attempt user authentication
/// TODO: Attempt sign up if email is not found... make the vibe shift clear to the user
Future<dynamic> login({
  required String email,
  required String password,
}) async {
  try {
    final Response response = await post(
      Uri.parse('https://your-activitypub-server.com/api/login'), // TODO
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
      headers: <String, String>{'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return AppUser.fromJson(jsonDecode(response.body));
    } else {
      return 'Failed: ${response.body}';
    }
  } catch (e) {
    return 'Error: ${e.toString()}';
  }
}

/// Logout current user
Future<String?> logout(BuildContext context) async {
  Navigator.of(context).popUntil((Route<dynamic> route) {
    return route.settings.name == homePath;
  });

  // TODO: Update the provider

  return null;
}

/// Update the [AppUser.avatarURL]
///
/// In dev - 'Something went wrong'
Future<String?> updateAvatar(String url) async {
  return 'Something went wrong';
}

/// Update the [AppUser.displayName]
///
/// In dev - 'Something went wrong'
Future<dynamic> updateName(String name) async {
  return 'Something went wrong';
}

// You //

/// [Stream] all [User]s that the current user can see
///
/// In dev - empty stream
dynamic streamUsers() {
  return const Stream<User>.empty();
  // or 'Something went wrong'
}
