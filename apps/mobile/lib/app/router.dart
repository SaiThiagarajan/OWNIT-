import 'package:flutter/material.dart';

import '../features/ai_result/presentation/ai_result_screen.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/otp_screen.dart';
import '../features/found_report/presentation/found_report_flow_screen.dart';
import '../features/history/presentation/history_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/lost_report/presentation/lost_report_flow_screen.dart';
import '../features/match/presentation/potential_match_screen.dart';
import '../features/messages/presentation/messages_screen.dart';
import '../features/onboarding/presentation/onboarding_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/search/presentation/search_screen.dart';
import '../features/splash/presentation/splash_screen.dart';

/// Route name constants. Screens not yet implemented (ownership
/// verification, notifications, chat, returns) have no entry here yet.
class AppRoutes {
  const AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String otp = '/otp';
  static const String home = '/home';
  static const String history = '/history';
  static const String messages = '/messages';
  static const String profile = '/profile';
  static const String search = '/search';
  static const String lostReport = '/lost-report';
  static const String foundReport = '/found-report';
  static const String aiResult = '/ai-result';
  static const String potentialMatch = '/potential-match';
}

/// Arguments passed to [AppRoutes.otp].
class OtpScreenArgs {
  const OtpScreenArgs({required this.phoneNumber});

  final String phoneNumber;
}

class AppRouter {
  const AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return _route(const SplashScreen(), settings);
      case AppRoutes.onboarding:
        return _route(const OnboardingScreen(), settings);
      case AppRoutes.login:
        return _route(const LoginScreen(), settings);
      case AppRoutes.otp:
        final args = settings.arguments as OtpScreenArgs?;
        return _route(OtpScreen(phoneNumber: args?.phoneNumber ?? ''), settings);
      case AppRoutes.home:
        return _route(const HomeScreen(), settings);
      case AppRoutes.history:
        return _route(const HistoryScreen(), settings);
      case AppRoutes.messages:
        return _route(const MessagesScreen(), settings);
      case AppRoutes.profile:
        return _route(const ProfileScreen(), settings);
      case AppRoutes.search:
        return _route(const SearchScreen(), settings);
      case AppRoutes.lostReport:
        return _route(const LostReportFlowScreen(), settings);
      case AppRoutes.foundReport:
        return _route(const FoundReportFlowScreen(), settings);
      case AppRoutes.aiResult:
        final args = settings.arguments as AiResultScreenArgs?;
        return _route(
          AiResultScreen(
            args: args ??
                const AiResultScreenArgs(
                  category: 'Item',
                  description: '',
                  confidence: 90,
                  hasMatch: false,
                ),
          ),
          settings,
        );
      case AppRoutes.potentialMatch:
        return _route(const PotentialMatchScreen(), settings);
      default:
        return _route(const SplashScreen(), settings);
    }
  }

  static PageRoute<dynamic> _route(Widget child, RouteSettings settings) {
    return MaterialPageRoute<dynamic>(builder: (_) => child, settings: settings);
  }
}
