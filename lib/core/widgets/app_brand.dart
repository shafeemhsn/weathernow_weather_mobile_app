import 'package:flutter/material.dart';

import '../constants/app_strings.dart';
import '../theme/app_colors.dart';

class AppBrand extends StatelessWidget {
  const AppBrand({super.key});

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).appBarTheme.titleTextStyle;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.cloud_outlined, color: Colors.white, size: 22),
        ),
        const SizedBox(width: 10),
        Text(
          AppStrings.appName,
          style: titleStyle?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
