import 'package:flutter/material.dart';

/// Custom button with consistent styling
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double height;
  final double borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = 50,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = backgroundColor ?? theme.primaryColor;
    final foregroundColor = textColor ??
        (isOutlined ? primaryColor : theme.colorScheme.onPrimary);

    final buttonStyle = isOutlined
        ? OutlinedButton.styleFrom(
            foregroundColor: foregroundColor,
            side: BorderSide(color: primaryColor, width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            minimumSize: Size(width ?? double.infinity, height),
          )
        : ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: foregroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            minimumSize: Size(width ?? double.infinity, height),
            elevation: 0,
          );

    final buttonContent = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          );

    return SizedBox(
      width: width,
      height: height,
      child: isOutlined
          ? OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: buttonStyle,
              child: buttonContent,
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: buttonStyle,
              child: buttonContent,
            ),
    );
  }
}

/// Icon button with loading state
class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? color;
  final double size;
  final String? tooltip;

  const CustomIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.isLoading = false,
    this.color,
    this.size = 24,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final button = IconButton(
      icon: isLoading
          ? SizedBox(
              width: size * 0.8,
              height: size * 0.8,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  color ?? Theme.of(context).iconTheme.color ?? Colors.black,
                ),
              ),
            )
          : Icon(icon, size: size, color: color),
      onPressed: isLoading ? null : onPressed,
    );

    if (tooltip != null) {
      return Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    return button;
  }
}

