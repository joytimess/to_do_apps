import 'package:flutter/material.dart';
import 'package:project_to_do_apps/login_page.dart';
import 'package:project_to_do_apps/templates/app_loading_page.dart';
import 'navigations/main_navigation.dart';
import 'auth_service.dart';

class AuthLayout extends StatelessWidget {
  const AuthLayout({super.key, this.pageIfNotConnected});

  final Widget? pageIfNotConnected;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: authService,
      builder: (context, authService, child) {
        return StreamBuilder(
          stream: authService.authStateChanges,
          builder: (context, snapshot) {
            Widget widget;
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const AppLoadingPage();
            } else if (snapshot.hasData) {
              return const MainNavigation();
            } else {
              return pageIfNotConnected ?? const LoginPage();
            }
          },
        );
      },
    );
  }
}
