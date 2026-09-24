import 'package:flutter/material.dart';
import '../app_theme.dart';

/// The pill-shaped "Register | Log In" switcher at the top of both
/// the Register (image 2) and Login (image 4) screens.
class AuthTabSwitcher extends StatelessWidget {
  final bool isRegisterActive;
  final VoidCallback onRegisterTap;
  final VoidCallback onLoginTap;

  const AuthTabSwitcher({
    super.key,
    required this.isRegisterActive,
    required this.onRegisterTap,
    required this.onLoginTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget pill(String text, bool active, VoidCallback onTap) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: active ? AppColors.primaryGreen : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: active ? Colors.white : AppColors.textDark,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          pill('Register', isRegisterActive, onRegisterTap),
          const SizedBox(width: 8),
          pill('Log In', !isRegisterActive, onLoginTap),
        ],
      ),
    );
  }
}
