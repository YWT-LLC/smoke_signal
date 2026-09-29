/* smoke_signal
 * Copyright (c) 2026 YWT (Empathetech LLC). All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import '../export.dart';

Stream<List<Signal>> streamSignals() {
  return const Stream<List<Signal>>.empty();
}

Future<String?> addToDB(Signal signal) {
  return validateSignal(signal);
}

Future<String?> toggleParticipation(Signal signal) async {
  return 'Something went wrong';
}

Future<String?> requestMembers(Signal signal, List<User> members) async {
  return 'Something went wrong';
}

Future<String?> resetSignal(Signal signal) async {
  return 'Something went wrong';
}

Future<String?> updateMessage(Signal signal, String message) async {
  return 'Something went wrong';
}

Future<String?> transferOwnership(Signal signal, User newOwner) async {
  return 'Something went wrong';
}

Future<String?> deleteSignal(Signal signal) async {
  return 'Something went wrong';
}

Future<String?> leaveSignal(Signal signal) async {
  return 'Something went wrong';
}
