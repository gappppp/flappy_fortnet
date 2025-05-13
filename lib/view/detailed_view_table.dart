import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DetailedViewTable extends StatelessWidget {
  final Map<String, dynamic> data;

  const DetailedViewTable({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    const double MAXKEYWIDTH = 150; 

    final entries = data.entries.toList();

    // // Get the longest key to size the left column properly
    // final longestKey = entries.map((e) => e.key.length).reduce((a, b) => a > b ? a : b);
    // final estimatedKeyWidth = (longestKey * 8.0) + 24; // estimate based on character width + padding

    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(entries.length, (index) {
            final entry = entries[index];
            final isEven = index % 2 == 0;
            final bgColor = isEven ? const Color.fromARGB(199, 123, 102, 160) : Colors.white;
        
            return Container(
              color: bgColor,
              child: Row(
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: MAXKEYWIDTH,
                      maxWidth: MAXKEYWIDTH,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: Text(entry.key, overflow: TextOverflow.ellipsis,),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(entry.value.toString(), overflow: TextOverflow.ellipsis,),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

double getLongestWrappedText(
  Iterable<String> keys,
  TextStyle style,
  double maxWidth,
) {
  double maxW = 0;

  for (var key in keys) {
    final p = RenderParagraph(
    TextSpan(text: key, style: style),
      textDirection: TextDirection.ltr
    )..layout(BoxConstraints(maxWidth: maxWidth));

    maxW = max(maxW, p.size.width);
  }

  return maxW;
}
