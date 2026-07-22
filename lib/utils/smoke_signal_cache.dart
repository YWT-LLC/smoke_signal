/* smoke_signal
 * Copyright (c) 2026 YWT (Empathetech LLC). All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import './export.dart';

import 'package:flutter/material.dart';
import 'package:open_ui/open_ui.dart';

class SmokeSignalCache extends EzAppCache {
  Locale _locale;
  Lang _l10n;

  SmokeSignalCache(Locale locale, Lang l10n) : _locale = locale, _l10n = l10n;

  Lang get l10n => _l10n;

  @override
  void init(_) {}

  @override
  Future<void> rebuild(EzCP config) async {
    if (_locale != config.locale) {
      _l10n = await Lang.delegate.load(config.locale);
      _locale = config.locale;
    }
  }
}

SmokeSignalCache _cache(EzCP config) => config.appCache as SmokeSignalCache;

Lang l10n(EzCP config) => _cache(config).l10n;
