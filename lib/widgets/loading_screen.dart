// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingScreen extends StatelessWidget {
  final bool showHeader;
  const LoadingScreen({
    super.key,
    this.showHeader = true,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Material(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Shimmer.fromColors(
            baseColor: Theme.of(context).colorScheme.onSurface.withOpacity(.3),
            highlightColor:
                Theme.of(context).colorScheme.onSurface.withOpacity(.7),
            period: Duration(milliseconds: 1000),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  2,
                  (_) => [
                    if (showHeader)
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.grey[300]?.withOpacity(.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    for (int i = 0; i < 5; i++) ...[
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey[300]?.withOpacity(.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 25,
                                width: 300,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300]?.withOpacity(.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                height: 25,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300]?.withOpacity(.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 15),
                  ],
                ).expand((e) => e).toList()),
          ),
        ),
      ),
    );
  }
}
