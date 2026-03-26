import 'package:flutter/material.dart';
import 'shimmer_loader.dart';

class BarberCardShimmer extends StatelessWidget {
  const BarberCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // صورة دائرية وهمية
            const ShimmerLoader(width: 56, height: 56, borderRadius: 28),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                ShimmerLoader(width: 120, height: 14),
                SizedBox(height: 8),
                ShimmerLoader(width: 80, height: 12),
                SizedBox(height: 8),
                ShimmerLoader(width: 100, height: 12),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
