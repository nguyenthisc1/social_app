/// Utility class for text manipulation
class TextHelpers {
  TextHelpers._();

  /// Truncate text to specified length with ellipsis
  static String truncate(String text, int maxLength, {String ellipsis = '...'}) {
    if (text.length <= maxLength) {
      return text;
    }
    return '${text.substring(0, maxLength)}$ellipsis';
  }

  /// Extract hashtags from text
  static List<String> extractHashtags(String text) {
    final hashtagRegex = RegExp(r'#[a-zA-Z0-9_]+');
    final matches = hashtagRegex.allMatches(text);
    return matches.map((match) => match.group(0)!).toList();
  }

  /// Extract mentions from text
  static List<String> extractMentions(String text) {
    final mentionRegex = RegExp(r'@[a-zA-Z0-9_]+');
    final matches = mentionRegex.allMatches(text);
    return matches.map((match) => match.group(0)!).toList();
  }

  /// Extract URLs from text
  static List<String> extractUrls(String text) {
    final urlRegex = RegExp(
      r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)',
    );
    final matches = urlRegex.allMatches(text);
    return matches.map((match) => match.group(0)!).toList();
  }

  /// Capitalize first letter of string
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  /// Convert string to title case
  static String toTitleCase(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) => capitalize(word.toLowerCase())).join(' ');
  }

  /// Remove extra whitespace
  static String removeExtraWhitespace(String text) {
    return text.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  /// Check if text contains only emoji
  static bool isOnlyEmoji(String text) {
    final emojiRegex = RegExp(
      r'^[\u{1F300}-\u{1F9FF}\u{2600}-\u{26FF}\u{2700}-\u{27BF}\u{FE00}-\u{FE0F}\u{1F000}-\u{1F02F}\u{1F0A0}-\u{1F0FF}\u{1F100}-\u{1F64F}\u{1F680}-\u{1F6FF}]+$',
      unicode: true,
    );
    return emojiRegex.hasMatch(text.replaceAll(RegExp(r'\s'), ''));
  }

  /// Count words in text
  static int wordCount(String text) {
    return text.trim().split(RegExp(r'\s+')).where((word) => word.isNotEmpty).length;
  }

  /// Format number with K, M suffixes
  static String formatCount(int count) {
    if (count < 1000) {
      return count.toString();
    } else if (count < 1000000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    } else if (count < 1000000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else {
      return '${(count / 1000000000).toStringAsFixed(1)}B';
    }
  }

  /// Generate initials from name
  static String getInitials(String name, {int maxChars = 2}) {
    final words = name.trim().split(RegExp(r'\s+'));
    if (words.isEmpty) return '';
    
    if (words.length == 1) {
      return words[0].substring(0, maxChars.clamp(1, words[0].length)).toUpperCase();
    }
    
    return words
        .take(maxChars)
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() : '')
        .join();
  }
}

