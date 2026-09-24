import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../widgets/feature_pill.dart';
import 'register_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: AppGradients.splashBackground),
        padding: const EdgeInsets.fromLTRB(24, 60, 24, 30),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.blur_circular, color: Colors.white, size: 32),
                  SizedBox(width: 10),
                  Text('Lumenox',
                      style: TextStyle(
                          color: Colors.white, fontSize: 26, fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                'Your space,\nyour lights\nReimagined.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  height: 1.15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Bring your lights to life. Control, customize, and automate '
                'stunning effects across any space — all from your phone.',
                style: TextStyle(color: Colors.white70, fontSize: 15, height: 1.4),
              ),
              const Spacer(),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: const [
                  FeaturePill(icon: Icons.memory, label: 'Multi-Zone Control'),
                  FeaturePill(icon: Icons.hourglass_bottom, label: 'Smart Scheduling'),
                  FeaturePill(icon: Icons.hub_outlined, label: 'Real-Time Sync'),
                  FeaturePill(icon: Icons.vpn_key_outlined, label: 'Installer-Ready Setup'),
                  FeaturePill(icon: Icons.share_outlined, label: 'Community Themes'),
                  FeaturePill(icon: Icons.description_outlined, label: 'HOA Compliance'),
                ],
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primaryGreen,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    );
                  },
                  child: const Text('Get Started'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
