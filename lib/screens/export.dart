/* smoke_signal
 * Copyright (c) 2022-2024 Empathetech LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

// Exports //

export 'home.dart';
export 'loading.dart';

export 'account/auth.dart';
export 'account/login.dart';
export 'account/profile_settings.dart';
export 'account/reset_password.dart';
export 'account/sign_up.dart';

export 'settings/settings_home.dart';

export 'settings/color_settings.dart';
export 'settings/image_settings.dart';
export 'settings/layout_settings.dart';
export 'settings/text_settings.dart';

export 'signal/create_signal.dart';
export 'signal/signal_board.dart';
export 'signal/signal_members.dart';

// Path names //

const String settingsPath = 'settings';
const String settingsRoute = '/settings';

const String textSettingsPath = 'text-settings';
const String textSettingsRoute = '/settings/text-settings';

const String layoutSettingsPath = 'layout-settings';
const String layoutSettingsRoute = '/settings/layout-settings';

const String colorSettingsPath = 'color-settings';
const String colorSettingsRoute = '/settings/color-settings';

const String imageSettingsPath = 'image-settings';
const String imageSettingsRoute = '/settings/image-settings';
