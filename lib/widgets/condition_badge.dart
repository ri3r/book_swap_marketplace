import 'package:flutter/material.dart';
import '../models/book_listing.dart';

class ConditionBadge extends StatelessWidget {
  final BookCondition condition;

  const ConditionBadge({super.key, required this.condition});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: condition.badgeColor.withAlpha((0.2 * 255).round()),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: condition.badgeColor),
      ),
      child: Text(
        condition.displayName,
        style: TextStyle(
          color: condition.badgeColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
