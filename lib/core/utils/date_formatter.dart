import 'package:intl/intl.dart';

/// Utility class for formatting dates and times
class DateFormatter {
  DateFormatter._();

  /// Formats date to "MMM dd, yyyy" (e.g., "Jan 15, 2025")
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  /// Formats time to "hh:mm a" (e.g., "02:30 PM")
  static String formatTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  /// Formats date and time to "MMM dd, yyyy hh:mm a"
  static String formatDateTime(DateTime date) {
    return DateFormat('MMM dd, yyyy hh:mm a').format(date);
  }

  static DateTime parseDate(dynamic value) {
    if (value == null) {
      return DateTime.fromMillisecondsSinceEpoch(0);
    }
    if (value is DateTime) return value;
    if (value is int) {
      // unix timestamp in seconds or milliseconds
      // decide by digit count
      return value > 10000000000
          ? DateTime.fromMillisecondsSinceEpoch(value)
          : DateTime.fromMillisecondsSinceEpoch(value * 1000);
    }
    if (value is String) {
      // try parsing as ISO string
      return DateTime.tryParse(value) ?? DateTime.fromMillisecondsSinceEpoch(0);
    }
    return DateTime.fromMillisecondsSinceEpoch(0);
  }

  /// Formats date to relative time (e.g., "2 hours ago", "3 days ago")
  static String timeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }

  /// Formats a timestamp for chat time dividers, e.g. "Today 14:30", "Yesterday 09:00", "Jan 15 08:30"
  static String formatDividerTime(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);
    final time = DateFormat('HH:mm').format(date);

    if (dateOnly == today) return 'Today $time';
    if (dateOnly == yesterday) return 'Yesterday $time';
    if (now.year == date.year) return '${DateFormat('MMM d').format(date)} $time';
    return '${DateFormat('MMM d, yyyy').format(date)} $time';
  }

  /// Formats a chat bubble timestamp (e.g., "Just now", "5m ago", "14:30")
  static String formatChatMessageTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  /// Formats a message timestamp to a compact relative label (e.g., "Just now", "5m", "2h", "3d")
  static String formatMessageTime(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inHours < 1) return '${difference.inMinutes}m';
    if (difference.inDays < 1) return '${difference.inHours}h';
    return '${difference.inDays}d';
  }

  /// Formats date to short relative time (e.g., "2h", "3d")
  static String shortTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}y';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }

  /// Formats date to "Today", "Yesterday", or "MMM dd"
  static String chatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'Today';
    } else if (dateOnly == yesterday) {
      return 'Yesterday';
    } else if (now.year == date.year) {
      return DateFormat('MMM dd').format(date);
    } else {
      return DateFormat('MMM dd, yyyy').format(date);
    }
  }

  /// Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Check if date is yesterday
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }
}
