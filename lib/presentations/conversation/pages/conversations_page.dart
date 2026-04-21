import 'package:flutter/material.dart';

class ConversationsPage extends StatelessWidget {
  const ConversationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: 10,
      separatorBuilder: (_, _) => Divider(
        height: 1,
        indent: 76,
        color: theme.colorScheme.outline.withAlpha(30),
      ),
      itemBuilder: (context, index) {
        final isUnread = index < 3;
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
          leading: CircleAvatar(
            radius: 26,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            child: Text(
              String.fromCharCode(65 + index),
              style: theme.textTheme.titleMedium,
            ),
          ),
          title: Text(
            'User ${index + 1}',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: isUnread ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          subtitle: Text(
            isUnread
                ? 'New message waiting for you...'
                : 'Last message in this conversation',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isUnread
                  ? theme.colorScheme.onSurface
                  : theme.colorScheme.outline,
              fontWeight: isUnread ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${index + 1}h ago',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
              if (isUnread) ...[
                const SizedBox(height: 4),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
