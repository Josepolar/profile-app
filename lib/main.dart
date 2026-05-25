import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:profile_app/firebase_options.dart';
import 'package:profile_app/screens/splash_screen.dart';
import 'package:profile_app/utils/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProfileApp());
}

class ProfileApp extends StatelessWidget {
  const ProfileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        barBackgroundColor: AppColors.background,
        textTheme: CupertinoTextThemeData(
          textStyle: TextStyle(
            fontFamily: '.SF Pro Text',
            color: AppColors.textPrimary,
          ),
        ),
      ),
      home: SplashScreen(),
    );
  }
}
