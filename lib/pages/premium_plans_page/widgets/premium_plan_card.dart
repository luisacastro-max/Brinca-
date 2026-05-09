import 'package:app_twins/pages/premium_plans_page/premium_plans_page_service.dart';
import 'package:app_twins/pages/premium_plans_page/widgets/premium_plan_feature_item.dart';
import 'package:flutter/material.dart';

class PremiumPlanCard extends StatelessWidget {
  const PremiumPlanCard({
    super.key,
    required this.plan,
    required this.isLoading,
    required this.onPressed,
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    required this.accentBorder,
    this.buttonGradient,
    this.buttonBorderGradient,
  });

  final PremiumPlanItem plan;
  final bool isLoading;
  final VoidCallback onPressed;
  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final Color accentBorder;
  final List<Color>? buttonGradient;
  final List<Color>? buttonBorderGradient;

  @override
  Widget build(BuildContext context) {
    final hasGradientButton = buttonGradient != null && buttonGradient!.length >= 2;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: accentBorder, width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10101828),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            child: plan.ctaType != 'checkout' ? Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: iconBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48, color: iconColor),
            ) : Container(
              width: 100,
              height: 100,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: buttonBorderGradient!,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: iconBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 48, color: iconColor),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              plan.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF101828),
                height: 1.15,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              plan.shortDescription,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF4A5565),
                height: 1.35,
              ),
            ),
          ),
          const SizedBox(height: 24),
          for (var i = 0; i < plan.features.length; i++) ...[
            PremiumPlanFeatureItem(text: plan.features[i]),
            if (i < plan.features.length - 1) const SizedBox(height: 12),
          ],
          const SizedBox(height: 24),
          _buildActionButton(hasGradientButton),
        ],
      ),
    );
  }

  Widget _buildActionButton(bool hasGradientButton) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: hasGradientButton
              ? LinearGradient(
                  colors: buttonGradient!,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,
          color: hasGradientButton ? null : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: hasGradientButton
                ? Colors.transparent
                : const Color(0xFFD0D5DD),
          ),
        ),
        child: TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(
                  plan.ctaLabel,
                  style: TextStyle(
                    fontSize: 18 / 1.2,
                    fontWeight: FontWeight.w700,
                    color: hasGradientButton
                        ? const Color(0xFFFFFFFF)
                        : const Color(0xFF344054),
                  ),
                ),
        ),
      ),
    );
  }
}
