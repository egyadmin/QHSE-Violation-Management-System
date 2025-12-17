import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/violations_provider.dart';
import 'providers/notifications_provider.dart';
import 'providers/approvals_provider.dart';
import 'presentation/widgets/navigation/main_layout.dart';
import 'presentation/screens/auth/login_screen.dart';

class QHSEApp extends StatelessWidget {
  const QHSEApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ViolationsProvider()),
        ChangeNotifierProvider(create: (_) => NotificationsProvider()),
        ChangeNotifierProvider(create: (_) => ApprovalsProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp(
            title: 'QHSE Violation Management',
            debugShowCheckedModeBanner: false,
            
            // Localization
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            
            // Theme
            theme: ThemeData(
              primaryColor: AppTheme.primaryGreen,
              scaffoldBackgroundColor: AppTheme.background,
              colorScheme: const ColorScheme.light(
                primary: AppTheme.primaryGreen,
                secondary: AppTheme.accentBlue,
              ),
              useMaterial3: true,
            ),
            
            // Show login or dashboard based on auth status
            home: authProvider.isAuthenticated 
                ? const MainLayout()
                : const LoginScreen(),
          );
        },
      ),
    );
  }
}
