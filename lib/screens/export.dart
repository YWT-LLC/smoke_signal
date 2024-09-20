/* smoke_signal
 * Copyright (c) 2022-2024 Empathetech LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

//* Class exports *//

// General //

export 'home.dart';
export 'loading.dart';

// Account //

export 'account/auth.dart';
export 'account/profile_settings.dart';
export 'account/reset_password.dart';

// Signal //

export 'signal/create_signal.dart';
export 'signal/signal_board.dart';
export 'signal/signal_members.dart';

// Settings //

export 'settings/settings_home.dart';

export 'settings/color_settings.dart';
export 'settings/image_settings.dart';
export 'settings/layout_settings.dart';
export 'settings/text_settings.dart';

//* Router paths *//

// Account //

/// 'reset-password'
const String resetPasswordPath = 'reset-password';

/// 'profile-settings'
const String profileSettingsPath = 'profile-settings';

// Signal //

/// 'create-signal'
const String createSignalPath = 'create-signal';

/// 'signal-members'
const String signalMembersPath = 'signal-members';

// Settings //

/// 'settings'
const String settingsPath = 'settings';

/// 'text-settings'
const String textSettingsPath = 'text-settings';

/// 'layout-settings'
const String layoutSettingsPath = 'layout-settings';

/// 'color-settings'
const String colorSettingsPath = 'color-settings';

/// 'image-settings'
const String imageSettingsPath = 'image-settings';
