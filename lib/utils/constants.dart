import 'package:flutter/cupertino.dart';

class AppColors {
  static const Color background = Color(0xFFF2F2F7);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color primary = Color(0xFF007AFF);
  static const Color primaryDark = Color(0xFF0051D5);
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF8E8E93);
  static const Color divider = Color(0xFFC6C6C8);
  static const Color error = Color(0xFFFF3B30);
}

class AppStrings {
  static const String appName = 'Profile';
  static const String loginTitle = 'Sign In';
  static const String registerTitle = 'Create Account';
  static const String profileTitle = 'Profile';
  static const String editProfileTitle = 'Edit Profile';
}

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}

class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double avatar = 80;
}

class FirestorePaths {
  static const String usersCollection = 'users';
}

class StoragePaths {
  static String profileImage(String uid) => 'profile_images/$uid/profile.jpg';
}
