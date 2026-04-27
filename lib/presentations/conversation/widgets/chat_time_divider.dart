import 'package:flutter/material.dart';
import 'package:social_app/core/theme/app_size.dart';
import 'package:social_app/core/utils/date_formatter.dart';

class ChatTimeDivider extends StatelessWidget {
  const ChatTimeDivider({super.key, required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSize.md),
      child: Row(
        children: [
          const SizedBox(width: AppSize.lg),
          Expanded(
            child: Divider(color: theme.colorScheme.outline.withAlpha(40)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSize.sm),
            child: Text(
              DateFormatter.formatDividerTime(date),
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ),
          Expanded(
            child: Divider(color: theme.colorScheme.outline.withAlpha(40)),
          ),
          const SizedBox(width: AppSize.lg),
        ],
      ),
    );
  }
}
