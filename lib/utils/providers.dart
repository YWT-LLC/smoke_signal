/* smoke_signal
 * Copyright (c) 2026 YWT (Empathetech LLC). All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import './export.dart';

import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  User? _user;

  UserProvider(User? user) : _user = user;

  User? get value => _user;

  void login(User user) {
    _user = user;
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
