import 'package:dorminic_co/models/utils/constants/colors.dart';
import 'package:dorminic_co/models/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class GlassBox extends StatelessWidget {
  const GlassBox({
    super.key,
    required this.width,
    required this.height,
    required this.child,
  });

  final width;
  final height;
  final child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg * 2),
      child: Container(
        width: width,
        height: height,
        color: Colors.transparent,
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(AppSizes.borderRadiusLg * 2),
                  border: Border.all(
                      color: const Color.fromARGB(255, 255, 255, 255)
                          .withOpacity(0.13),
                      width: 2),
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.blue600.withOpacity(0.3),
                        AppColors.blue600.withOpacity(0.05),
                        Colors.transparent,
                        Colors.transparent,
                        AppColors.teal400.withOpacity(0.3),
                      ]),
                ),
              ),
            ),
            Center(
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

class SolidGlassBox extends StatelessWidget {
  const SolidGlassBox({
    super.key,
    required this.width,
    required this.height,
    required this.child,
  });

  final width;
  final height;
  final child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
      child: Container(
        width: width,
        height: height,
        color: AppColors.grey.withOpacity(0.01),
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(AppSizes.borderRadiusLg),
                  border: Border.all(
                      color: AppColors.white
                          .withOpacity(0.13), width: 1),
                ),
              ),
            ),
            Center(
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
