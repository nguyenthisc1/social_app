import 'package:flutter/material.dart';
import 'package:social_app/core/widgets/error_view.dart';
import 'package:social_app/core/widgets/in_app_status_banner.dart';
import 'package:social_app/core/widgets/loading_indicator.dart';

class InAppStatusWrapper extends StatelessWidget {
  const InAppStatusWrapper({
    super.key,
    required this.child,
    required this.hasContent,
    required this.isLoading,
    this.errorMessage,
    this.loadingText = 'Loading...',
  });

  final Widget child;
  final bool hasContent;
  final bool isLoading;
  final String? errorMessage;
  final String loadingText;

  @override
  Widget build(BuildContext context) {
    final normalizedError = errorMessage?.trim();
    final hasError = normalizedError != null && normalizedError.isNotEmpty;

    if (isLoading && !hasContent) {
      return const LoadingIndicator();
    }

    if (hasError && !hasContent) {
      return ErrorView(message: normalizedError);
    }

    final bannerText = isLoading
        ? loadingText
        : hasError
        ? normalizedError
        : null;

    return Column(
      children: [
        InAppStatusBanner(
          show: bannerText != null,
          text: bannerText ?? '',
        ),
        Expanded(child: child),
      ],
    );
  }
}
