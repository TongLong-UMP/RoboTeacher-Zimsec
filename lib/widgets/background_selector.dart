import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/theme_service.dart';

const List<Map<String, String>> kBackgroundOptions = [
  {'label': 'Default', 'asset': ''},
  {
    'label': 'Savanna Sunset',
    'asset': 'assets/backgrounds/african_savanna.gif'
  },
  {
    'label': 'African Village',
    'asset': 'assets/backgrounds/african_village.gif'
  },
  {
    'label': 'Wildlife Parade',
    'asset': 'assets/backgrounds/wildlife_parade.gif'
  },
  {
    'label': 'Great Zimbabwe Ruins',
    'asset': 'assets/backgrounds/zimbabwe_ruins.gif'
  },
  {
    'label': 'Shona Village Life',
    'asset': 'assets/backgrounds/shona_village.gif'
  },
  {'label': 'Victoria Falls', 'asset': 'assets/backgrounds/victoria_falls.gif'},
  {'label': 'Tech Classroom', 'asset': 'assets/backgrounds/tech_classroom.gif'},
  {'label': 'City Skyline', 'asset': 'assets/backgrounds/city_skyline.gif'},
  {
    'label': 'Abstract Digital',
    'asset': 'assets/backgrounds/abstract_digital.gif'
  },
];

class BackgroundSelector extends StatelessWidget {
  const BackgroundSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final selected = themeService.backgroundAsset ?? '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Background', style: TextStyle(fontWeight: FontWeight.bold)),
        DropdownButton<String>(
          value: selected,
          items: kBackgroundOptions.map((option) {
            return DropdownMenuItem<String>(
              value: option['asset'],
              child: Text(option['label'] ?? ''),
            );
          }).toList(),
          onChanged: (value) {
            themeService.setBackgroundAsset(value == '' ? null : value);
          },
        ),
        if (selected.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Image.asset(selected, height: 100, fit: BoxFit.cover),
          ),
      ],
    );
  }
}
