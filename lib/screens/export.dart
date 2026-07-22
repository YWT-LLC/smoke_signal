/* smoke_signal
 * Copyright (c) 2026 YWT (Empathetech LLC). All rights reserved.
 * See LICENSE for distribution and usage details.
 */

// Exports //

export 'error.dart';
export 'home.dart';
export 'settings.dart';

export 'account/auth.dart';
export 'account/profile_settings.dart';
export 'account/reset_password.dart';

export 'signal/create_signal.dart';
export 'signal/signal_board.dart';
export 'signal/signal_members.dart';

// Route names //

/// settings
const String settingsHubPath = 'settings';

/// reset-password
const String resetPasswordPath = 'reset-password';

/// profile-settings
const String profileSettingsPath = 'profile-settings';

/// create-signal
const String createSignalPath = 'create-signal';

/// signal-members
const String signalMembersPath = 'signal-members';
