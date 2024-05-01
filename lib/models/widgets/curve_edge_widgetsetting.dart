
import 'package:dorminic_co/models/utils/constants/colors.dart';
import 'package:dorminic_co/models/widgets/custom_shapes/circular_container.dart';
import 'package:flutter/material.dart';

class CurveEdgeWidgetsetting extends StatelessWidget {
  const CurveEdgeWidgetsetting({
    super.key,
    required this.child,
  });

  final Widget child;
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      child: Container(
        padding: const EdgeInsets.all(0),
        decoration: const BoxDecoration(
          color: AppColors.dark,
          borderRadius: BorderRadius.only(bottomLeft:Radius.circular(30), bottomRight:Radius.circular(30))),
        child: SizedBox(
          height: 220,
          child: Stack(
            children: [
              Positioned(top: -250, right: -250, child: CircularContainer(backgroundColor: AppColors.textWhite.withOpacity(0.1))),
              Positioned(top: 50, right: -100, child: CircularContainer(backgroundColor: AppColors.textWhite.withOpacity(0.1))),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

