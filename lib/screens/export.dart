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
export 'account/login.dart';
export 'account/profile_settings.dart';
export 'account/reset_password.dart';
export 'account/sign_up.dart';

// Settings //

export 'settings/settings_home.dart';

export 'settings/color_settings.dart';
export 'settings/image_settings.dart';
export 'settings/layout_settings.dart';
export 'settings/text_settings.dart';

// Signal //

export 'signal/create_signal.dart';
export 'signal/signal_board.dart';
export 'signal/signal_members.dart';

//* Router paths *//

// General //

/// 'loading'
const String loadingPath = 'loading';

/// '/loading'
const String loadingRoute = '/loading';

// Account //

/// 'auth'
const String authPath = 'auth';

/// '/account/auth'
const String authRoute = '/account/auth';

/// 'login'
const String loginPath = 'login';

/// '/account/login'
const String loginRoute = '/account/login';

/// 'profile-settings'
const String profileSettingsPath = 'profile-settings';

/// '/account/profile-settings'
const String profileSettingsRoute = '/account/profile-settings';

/// 'reset-password'
const String resetPasswordPath = 'reset-password';

/// '/account/reset-password'
const String resetPasswordRoute = '/account/reset-password';

/// 'sign-up'
const String signUpPath = 'sign-up';

/// '/account/sign-up'
const String signUpRoute = '/account/sign-up';

// Settings //

/// 'settings'
const String settingsPath = 'settings';

/// '/settings'
const String settingsRoute = '/settings';

/// 'text-settings'
const String textSettingsPath = 'text-settings';

/// '/settings/text-settings'
const String textSettingsRoute = '/settings/text-settings';

/// 'layout-settings'
const String layoutSettingsPath = 'layout-settings';

/// '/settings/layout-settings'
const String layoutSettingsRoute = '/settings/layout-settings';

/// 'color-settings'
const String colorSettingsPath = 'color-settings';

/// '/settings/color-settings'
const String colorSettingsRoute = '/settings/color-settings';

/// 'image-settings'
const String imageSettingsPath = 'image-settings';

/// '/settings/image-settings'
const String imageSettingsRoute = '/settings/image-settings';

// Signal //

/// 'create-signal'
const String createSignalPath = 'create-signal';

/// '/signal/create-signal'
const String createSignalRoute = '/signal/create-signal';

/// 'signal-board'
const String signalBoardPath = 'signal-board';

/// '/signal/signal-board'
const String signalBoardRoute = '/signal/signal-board';

/// 'signal-members'
const String signalMembersPath = 'signal-members';

/// '/signal/signal-members'
const String signalMembersRoute = '/signal/signal-members';
