/* smoke_signal
 * Copyright (c) 2026 YWT (Empathetech LLC). All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:open_ui/open_ui.dart';
import 'package:email_validator/email_validator.dart';

/// r'^[\d\w\s-_!,?^]{3,20}$'
final RegExp inputRegex = RegExp(r"^[\w\d\s,:.?!_^'-]{3,20}$");

String? _noEmpty(String? toCheck) =>
    (toCheck == null || toCheck.isEmpty) ? 'Cannot be empty' : null;

String? validateEmail(String? toCheck) =>
    _noEmpty(toCheck) ?? (EmailValidator.validate(toCheck!) ? null : 'Invalid email');

String? validateDisplayName(String? toCheck) =>
    _noEmpty(toCheck) ?? (inputRegex.hasMatch(toCheck!) ? null : 'Invalid display name');

String? validateUrl(String? toCheck) =>
    _noEmpty(toCheck) ?? (ezUrlCheck(toCheck!) ? null : 'Invalid URL');

String? validateSignalTitle(String? toCheck) =>
    _noEmpty(toCheck) ?? (inputRegex.hasMatch(toCheck!) ? null : 'Invalid title');

String? validateSignalMessage(String? toCheck) =>
    _noEmpty(toCheck) ?? (inputRegex.hasMatch(toCheck!) ? null : 'Invalid message');
