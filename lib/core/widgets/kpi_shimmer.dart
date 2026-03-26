import 'package:flutter/material.dart';
import 'shimmer_loader.dart';

class KpiRowShimmer extends StatelessWidget {
  const KpiRowShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: List.generate(3, (index) => Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 0 : 6,
              right: index == 2 ? 0 : 6,
            ),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ShimmerLoader(width: 32, height: 32, borderRadius: 8),
                    SizedBox(height: 12),
                    ShimmerLoader(width: 48, height: 20),
                    SizedBox(height: 6),
                    ShimmerLoader(width: 72, height: 12),
                  ],
                ),
              ),
            ),
          ),
        )),
      ),
    );
  }
}
