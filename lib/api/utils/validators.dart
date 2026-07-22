/* smoke_signal
 * Copyright (c) 2026 YWT (Empathetech LLC). All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import '../export.dart';

import 'package:email_validator/email_validator.dart';

const String inputRules =
    """Display names, signal titles, and signal messages can be 3-20 characters long.

Letters, numbers, spaces, and the following special characters are allowed...

, : . ? ! _ ^ - ' """;

/// r'^[\d\w\s-_!,?^]{3,20}$'
final RegExp inputRegex = RegExp(r"^[\w\d\s,:.?!_^'-]{3,20}$");

/// Validate emails via [EmailValidator]
String? validateEmail(String? toCheck) {
  return (toCheck != null && !EmailValidator.validate(toCheck)) ? 'Invalid email' : null;
}

/// Validate display names via [inputRegex]
String? validateDisplayName(String? toCheck) {
  return (toCheck != null && !inputRegex.hasMatch(toCheck)) ? 'Invalid display name' : null;
}

/// Validate URLs via [Uri.tryParse]
String? validateUrl(String? toCheck) {
  return (toCheck != null && !Uri.tryParse(toCheck)!.hasAbsolutePath) ? 'Invalid URL' : null;
}

/// Validate signal titles via [inputRegex]
String? validateSignalTitle(String? toCheck) {
  return (toCheck != null && !inputRegex.hasMatch(toCheck)) ? 'Invalid title' : null;
}

/// Validate signal notification messages via [inputRegex]
String? validateSignalMessage(String? toCheck) {
  return (toCheck != null && !inputRegex.hasMatch(toCheck)) ? 'Invalid message' : null;
}

/// Validate that the [signal] can be created
/// Reasons for failure:
///   - 'Name is already taken'
///
/// In dev - 'Name is already taken'
Future<String?> validateSignal(Signal signal) async {
  return 'Name is already taken';
}
