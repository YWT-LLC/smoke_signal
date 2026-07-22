/* smoke_signal
 * Copyright (c) 2026 YWT (Empathetech LLC). All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import '../export.dart';

/// Stream all [Signal]s from the DB
///
/// In dev - empty stream
dynamic streamSignals() {
  return const Stream<Signal>.empty();
  // or 'Something went wrong'
}

/// Add the new [signal] to the DB
///
/// In dev - 'Name is already taken'
Future<String?> addToDB(Signal signal) => validateSignal(signal);

/// Toggle the [AppUser]s participation for [signal]
///
/// In dev - 'Something went wrong'
Future<String?> toggleParticipation(Signal signal) async {
  return 'Something went wrong';
}

/// Create a requests for all [members]
///
/// In dev - 'Something went wrong'
Future<String?> requestMembers(Signal signal, List<User> members) async {
  return 'Something went wrong';
}

/// De-activate all members
///
/// In dev - 'Something went wrong'
Future<String?> resetSignal(Signal signal) async {
  return 'Something went wrong';
}

/// Update the [Signal.message]
///
/// In dev - 'Something went wrong'
Future<String?> updateMessage(Signal signal, String message) async {
  return 'Something went wrong';
}

/// Transfer the [signal] to a [newOwner]
///
/// In dev - 'Something went wrong'
Future<String?> transferOwnership(Signal signal, User newOwner) async {
  return 'Something went wrong';
}

/// Delete the [signal] and clear related prefs (upon success)
///
/// In dev - 'Something went wrong'
Future<String?> deleteSignal(Signal signal) async {
  return 'Something went wrong';
}

/// Leave the [signal]; it's recommended to prompt the [AppUser] to clear the related prefs (upon success)
///
/// In dev - 'Something went wrong'
Future<String?> leaveSignal(Signal signal) async {
  return 'Something went wrong';
}
