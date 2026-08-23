/// 4px-base spacing scale plus the fixed component measurements from the
/// OWNIT design spec. Prefer these constants over literal numbers anywhere
/// layout spacing, padding, or corner radii are needed.
class AppSpacing {
  const AppSpacing._();

  static const double s4 = 4;
  static const double s8 = 8;
  static const double s12 = 12;
  static const double s16 = 16;
  static const double s20 = 20;
  static const double s24 = 24;
  static const double s32 = 32;
  static const double s40 = 40;
  static const double s48 = 48;

  static const double screenHorizontal = 20;
  static const double cardPadding = 16;

  static const double controlHeight = 52;
  static const double otpHeight = 44;
  static const double minTapTarget = 44;

  static const double radiusControl = 14;
  static const double radiusCard = 20;
  static const double radiusBottomSheet = 28;
}
