import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

final themeListProvider = NotifierProvider<ThemeColorList, List<AppThemeColor>>(ThemeColorList.new);
final appThemeColor = Provider<List<AppThemeColor>>((ref) => ref.watch(themeListProvider));

final textFieldBorderRadiusState = StateProvider<double>((_) => 4.0);
final buttonBorderRadiusState = StateProvider<double>((_) => 4.0);
final outlinedButtonWidthState = StateProvider<double>((_) => 2.0);
final themeAppState = StateProvider((ref) => ref.read(appThemeColor).first);
final brightnessState = StateProvider((_) => Brightness.light);

const defaultBzbeDemoColor = Color(0xffF9A601);
final defaultBzbsDemoTheme = AppThemeColor(
  id: uuid.v4(),
  label: 'Bzbe demo (default)',
  primaryColor: defaultBzbeDemoColor,
  onPrimaryColor: Colors.white,
  dividerColor: const Color(0xffB3B3B3),
  borderColor: const Color(0xffB3B3B3),
);

class AppThemeColor {
  late String id;
  String? label;
  Color primaryColor;
  Color? onPrimaryColor;
  Color? dividerColor;
  Color borderColor;
  AppThemeColor({
    required this.id,
    required this.label,
    required this.primaryColor,
    this.onPrimaryColor,
    this.dividerColor,
    this.borderColor = const Color(0xFF000000),
  });

  AppThemeColor copyWith({
    String? id,
    String? label,
    Color? primaryColor,
    Color? onPrimaryColor,
    Color? dividerColor,
    Color? borderColor,
  }) =>
      AppThemeColor(
        id: id ?? this.id,
        label: label ?? this.label,
        primaryColor: primaryColor ?? this.primaryColor,
        onPrimaryColor: onPrimaryColor ?? this.onPrimaryColor,
        dividerColor: dividerColor ?? this.dividerColor,
        borderColor: borderColor ?? this.borderColor,
      );
}

class ThemeColorList extends Notifier<List<AppThemeColor>> {
  @override
  List<AppThemeColor> build() {
    return [
      defaultBzbsDemoTheme,
      defaultBzbsDemoTheme.copyWith(
        id: uuid.v4(),
        label: 'M3 Baseline',
        primaryColor: const Color(0xff6750a4),
      ),
      defaultBzbsDemoTheme.copyWith(
        id: uuid.v4(),
        label: 'Indigo',
        primaryColor: Colors.indigo,
      ),
      defaultBzbsDemoTheme.copyWith(
        id: uuid.v4(),
        label: 'Blue',
        primaryColor: Colors.blue,
      ),
      defaultBzbsDemoTheme.copyWith(
        id: uuid.v4(),
        label: 'Teal',
        primaryColor: Colors.teal,
      ),
      defaultBzbsDemoTheme.copyWith(
        id: uuid.v4(),
        label: 'Green',
        primaryColor: Colors.green,
      ),
      defaultBzbsDemoTheme.copyWith(
        id: uuid.v4(),
        label: 'Yellow',
        primaryColor: Colors.yellow,
        onPrimaryColor: Colors.black,
      ),
      defaultBzbsDemoTheme.copyWith(
        id: uuid.v4(),
        label: 'Orange',
        primaryColor: Colors.orange,
      ),
      defaultBzbsDemoTheme.copyWith(
        id: uuid.v4(),
        label: 'Deep Orange',
        primaryColor: Colors.deepOrange,
      ),
      defaultBzbsDemoTheme.copyWith(
        id: uuid.v4(),
        label: 'Pink',
        primaryColor: Colors.pink,
      ),
    ];
  }

  void add(AppThemeColor value) {
    state = [
      ...state,
      value,
    ];
  }

  void edit(AppThemeColor target) {
    state = [
      for (final themeColor in state)
        if (themeColor.id == target.id) target else themeColor,
    ];
  }

  void remove(AppThemeColor target) {
    state = state.where((todo) => todo.id != target.id).toList();
  }
}
