/* smoke_signal
 * Copyright (c) 2026 Empathetech LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

//* Class exports *//

// General //

export 'error.dart';
export 'home.dart';

// Account //

export 'account/auth.dart';
export 'account/profile_settings.dart';
export 'account/reset_password.dart';

// Signal //

export 'signal/create_signal.dart';
export 'signal/signal_board.dart';
export 'signal/signal_members.dart';

// Settings //

export 'settings/home.dart';

export 'settings/color.dart';
export 'settings/design.dart';
export 'settings/layout.dart';
export 'settings/text.dart';

//* Router paths *//

// Account //

/// reset-password
const String resetPasswordPath = 'reset-password';

/// profile-settings
const String profileSettingsPath = 'profile-settings';

// Signal //

/// create-signal
const String createSignalPath = 'create-signal';

/// signal-members
const String signalMembersPath = 'signal-members';

// Settings //

/// settings-home
const String settingsHomePath = 'settings-home';

/// color-settings
const String colorSettingsPath = 'color-settings';

/// design-settings
const String designSettingsPath = 'design-settings';

/// layout-settings
const String layoutSettingsPath = 'layout-settings';

/// text-settings
const String textSettingsPath = 'text-settings';
