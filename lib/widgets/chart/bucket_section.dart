import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/chart/legend_item.dart';
import 'package:flutter/material.dart';

class BucketSection extends StatefulWidget {
  final String title;
  final List<ExpenseBucket> buckets;

  const BucketSection({
    super.key,
    required this.title,
    required this.buckets,
  });

  @override
  State<BucketSection> createState() => _BucketSectionState();
}

class _BucketSectionState extends State<BucketSection> {
  bool isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isExpanded
                        ? Icons.expand_less
                        : Icons.expand_more,
                  ),
                  onPressed: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                ),
              ],
            ),

            // CONTENT
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Wrap(
                spacing: 12,
                runSpacing: 8,
                children: widget.buckets
                    .map((bucket) => LegendItem(bucket: bucket))
                    .toList(),
              ),
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 250),
            ),
          ],
        ),
      ),
    );
  }
}