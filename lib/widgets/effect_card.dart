import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../models/effect_model.dart';

class EffectCard extends StatelessWidget {
  final EffectModel effect;
  final ValueChanged<bool> onToggle;

  const EffectCard({super.key, required this.effect, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(effect.name,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.gradient, size: 16, color: AppColors.primaryGreen),
                    const SizedBox(width: 6),
                    Text(effect.effectType,
                        style: const TextStyle(
                            color: AppColors.primaryGreen,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text('Colors:', style: TextStyle(color: AppColors.textGrey)),
                    const SizedBox(width: 8),
                    ...effect.colorSwatches.map(
                      (c) => Container(
                        margin: const EdgeInsets.only(right: 4),
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(color: c, shape: BoxShape.circle),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 16, color: AppColors.textGrey),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        effect.zones.join(' • '),
                        style: const TextStyle(color: AppColors.textGrey),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text.rich(
                  TextSpan(
                    style: const TextStyle(color: AppColors.textGrey),
                    children: [
                      const TextSpan(text: 'Up time- Off time: '),
                      TextSpan(
                        text: '${effect.upTime} • ${effect.offTime}',
                        style: const TextStyle(
                            color: AppColors.primaryGreen, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: effect.isOn,
            activeColor: Colors.white,
            activeTrackColor: AppColors.primaryGreen,
            onChanged: onToggle,
          ),
        ],
      ),
    );
  }
}
