import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/theme_service.dart';

class BackgroundContainer extends StatelessWidget {
  final Widget child;
  const BackgroundContainer({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final asset = themeService.backgroundAsset;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        image: asset != null && asset.isNotEmpty
            ? DecorationImage(
                image: AssetImage(asset),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: child,
    );
  }
}
