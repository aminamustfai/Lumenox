import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../app_theme.dart';

class ForgotPasswordSentScreen extends StatelessWidget {
  const ForgotPasswordSentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.authBackground),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
                  label: const Text('Back', style: TextStyle(color: AppColors.textDark)),
                ),
                const SizedBox(height: 10),
                const Text('Sent successfully.',
                    style: TextStyle(
                        fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.textDark)),
                const SizedBox(height: 8),
                const Text('Please check your email for verification link.',
                    style: TextStyle(color: AppColors.textGrey)),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => launchUrl(Uri.parse('mailto:')),
                  child: const Text('Open Mail Box'),
                ),
                const Spacer(),
                const Center(
                  child: Text(
                    "Didn't received the email? make sure to check the spam folder or Resend",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textGrey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// NOTE: This screen is only reached from "forgot password" (image 6), which
// is why it does not need its own resend-verification logic like image 3 -
// resending here just means calling AuthService().sendPasswordResetEmail()
// again with the same email if you want to wire up the "Resend" text link.
