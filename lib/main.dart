import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants/colors.dart';

import 'injection.dart';
import 'router/app_router.dart';

void main() {
  configureDependencies();
  runApp(const BaeminApp());
}

class BaeminApp extends StatelessWidget {
  const BaeminApp({super.key});

  static final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _appRouter.config(),
      title: 'Baemin Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
        ),
        textTheme: GoogleFonts.notoSansTextTheme(Theme.of(context).textTheme),
        useMaterial3: true,
      ),
    );
  }
}
