/* smoke_signal
 * Copyright (c) 2022-2025 Empathetech LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:flutter/material.dart';
import 'package:empathetech_ss_api/empathetech_ss_api.dart';

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
