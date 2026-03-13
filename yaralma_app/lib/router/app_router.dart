import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/onboarding/faith_shield_screen.dart';
import '../screens/onboarding/value_agreement_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/holy_lock/holy_lock_screen.dart';
import '../screens/youtube_guardian/youtube_guardian_screen.dart';
import '../screens/netflix_guardian/netflix_guardian_screen.dart';
import '../screens/wolof_guardian/wolof_guardian_screen.dart';

/// Route names and paths.
class AppRoutes {
  static const String valueAgreement = 'value-agreement';
  static const String faithShield = 'faith-shield';
  static const String home = 'home';
  static const String holyLock = 'holy-lock';
  static const String youtubeGuardian = 'youtube-guardian';
  static const String netflixGuardian = 'netflix-guardian';
  static const String wolofGuardian = 'wolof-guardian';

  static const String pathValueAgreement = '/onboarding/value-agreement';
  static const String pathFaithShield = '/onboarding/faith-shield';
  static const String pathHome = '/home';
  static const String pathHolyLock = '/holy-lock';
  static const String pathYouTubeGuardian = '/youtube-guardian';
  static const String pathNetflixGuardian = '/netflix-guardian';
  static const String pathWolofGuardian = '/wolof-guardian';
}

GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: AppRoutes.pathValueAgreement,
    routes: [
      GoRoute(
        path: '/onboarding/:screen',
        builder: (context, state) {
          final screen = state.pathParameters['screen'];
          if (screen == AppRoutes.faithShield) {
            return const FaithShieldScreen();
          }
          return const ValueAgreementScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.pathHome,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.pathHolyLock,
        builder: (context, state) => const HolyLockScreen(),
      ),
      GoRoute(
        path: AppRoutes.pathYouTubeGuardian,
        builder: (context, state) => const YouTubeGuardianScreen(),
      ),
      GoRoute(
        path: AppRoutes.pathNetflixGuardian,
        builder: (context, state) => const NetflixGuardianScreen(),
      ),
      GoRoute(
        path: AppRoutes.pathWolofGuardian,
        builder: (context, state) => const WolofGuardianScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text(
          'Page not found',
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ),
    ),
  );
}
