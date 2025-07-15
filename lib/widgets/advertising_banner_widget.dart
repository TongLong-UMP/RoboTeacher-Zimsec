import 'package:flutter/material.dart';

/// A reusable advertising banner widget for displaying image or text ads.
/// Can be placed at the top of any section or screen.
class AdvertisingBannerWidget extends StatelessWidget {
  final String? imageUrl;
  final String? adText;
  final VoidCallback? onTap;

  const AdvertisingBannerWidget({
    super.key,
    this.imageUrl,
    this.adText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.yellow[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orangeAccent, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            if (imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl!,
                  height: 48,
                  width: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image, size: 48, color: Colors.orange),
                ),
              ),
            if (imageUrl != null) const SizedBox(width: 12),
            Expanded(
              child: Text(
                adText ?? 'Sponsored',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.deepOrange,
                ),
              ),
            ),
            const Icon(Icons.campaign, color: Colors.orange, size: 28),
          ],
        ),
      ),
    );
  }
}
