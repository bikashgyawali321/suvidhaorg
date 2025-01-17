import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class CustomButton extends StatelessWidget {
  CustomButton({
    super.key,
    required this.label,
    this.onPressed,
    this.backgroundColor,
    this.loading = false,
    this.disabled = false,
  }) : foregroundColor = backgroundColor?.computeLuminance() == null
            ? null
            : backgroundColor!.computeLuminance() > .5
                ? Colors.black
                : Colors.white;
  final Color? foregroundColor;
  final String label;
  final Color? backgroundColor;
  final VoidCallback? onPressed;
  final bool loading, disabled;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: disabled ? null : onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(backgroundColor),
        foregroundColor: WidgetStatePropertyAll(foregroundColor),
      ),
      child: loading
          ? SizedBox(
              height: 20,
              width: 20,
              child: LoadingIndicator(
                indicatorType: Indicator.ballBeat,
              )
            )
          : Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}
