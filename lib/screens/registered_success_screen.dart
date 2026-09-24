import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../app_theme.dart';
import '../services/auth_service.dart';

class RegisteredSuccessScreen extends StatefulWidget {
  const RegisteredSuccessScreen({super.key});

  @override
  State<RegisteredSuccessScreen> createState() => _RegisteredSuccessScreenState();
}

class _RegisteredSuccessScreenState extends State<RegisteredSuccessScreen> {
  final _auth = AuthService();
  late final TapGestureRecognizer _resendRecognizer;

  @override
  void initState() {
    super.initState();
    _resendRecognizer = TapGestureRecognizer()
      ..onTap = () async {
        await _auth.resendVerificationEmail();
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Verification email resent.')));
        }
      };
  }

  @override
  void dispose() {
    _resendRecognizer.dispose();
    super.dispose();
  }

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
                const Text('Registered successfully.',
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
                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(color: AppColors.textGrey),
                      children: [
                        const TextSpan(
                            text: "Didn't received the email? make sure to check "
                                "the spam folder or "),
                        TextSpan(
                          text: 'Resend',
                          style: const TextStyle(
                              color: AppColors.primaryGreen, fontWeight: FontWeight.w700),
                          recognizer: _resendRecognizer,
                        ),
                      ],
                    ),
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
