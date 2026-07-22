/* smoke_signal
 * Copyright (c) 2026 YWT (Empathetech LLC). All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import '../../api/export.dart';

import 'package:flutter/material.dart';

class AppUserProvider extends ChangeNotifier {
  AppUser? _user;

  AppUserProvider(AppUser? user) : _user = user;

  AppUser? get value => _user;

  void login(AppUser user) {
    _user = user;
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
