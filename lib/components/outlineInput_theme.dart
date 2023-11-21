import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../app_colors.dart';

class OutlineInputTheme extends ConsumerWidget {
  final Widget child;
  const OutlineInputTheme({super.key, required this.child});

  @override
  Widget build(BuildContext context, ref) {
    final themeAppColor = ref.watch(themeAppState);
    final borderRadius = ref.watch(textFieldBorderRadiusState);
    return Theme(
        data: Theme.of(context).copyWith(
          inputDecorationTheme: InputDecorationTheme(
            outlineBorder: BorderSide(
              width: 2,
              color: themeAppColor.borderColor,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: themeAppColor.borderColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                width: 2,
                color: themeAppColor.primaryColor,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: themeAppColor.borderColor,
              ),
            ),
          ),
        ),
        child: child);
  }
}
