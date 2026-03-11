import 'package:flutter/material.dart';

class BizColors {
  // Primary accent — same sage grey-green as Bronet
  static const sage         = Color(0xFFA8B6A1);
  static const sageDark     = Color(0xFF7B9180);
  static const sageLight    = Color(0xFFBEC8B8);
  static const sageBg       = Color(0xFFE4EDEA);

  // Backgrounds
  static const bgApp        = Color(0xFFF0F5EC);
  static const bgCard       = Color(0xFFFFFFFF);
  static const bgSurface    = Color(0xFFF0F4ED);
  static const bgMuted      = Color(0xFFE4EAE0);

  // Dark
  static const forest       = Color(0xFF2C3528);
  static const forestDeep   = Color(0xFF1E2A1A);

  // Text
  static const textPrimary  = Color(0xFF2C3528);
  static const textMuted    = Color(0xFF6E7E68);
  static const textLight    = Color(0xFF9AAA94);

  // Status
  static const red          = Color(0xFFFF4D6A);
  static const amber        = Color(0xFFFFB830);
  static const green        = Color(0xFF3DAD7F);
  static const blue         = Color(0xFF4A90D9);

  // 0x14 = ~8% opacity on black
  static const List<BoxShadow> shadow = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 16,
      offset: Offset(0, 4),
    )
  ];

  // 0x24 = ~14% opacity on black
  static const List<BoxShadow> shadowStrong = [
    BoxShadow(
      color: Color(0x24000000),
      blurRadius: 28,
      offset: Offset(0, 8),
    )
  ];
}
