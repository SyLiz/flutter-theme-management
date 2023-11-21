import 'package:design_tokens_test/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_colors.dart';
import 'components/outlineInput_theme.dart';
import 'page/change_theme.dart';

const rowDivider = SizedBox(width: 20);
const colDivider = SizedBox(height: 10);
const tinySpacing = 3.0;
const smallSpacing = 10.0;
const double cardWidth = 115;
const double widthConstraint = 450;

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brightness = ref.watch(brightnessState);
    final themeAppColor = ref.watch(themeAppState);
    final buttonBorderRadius = ref.watch(buttonBorderRadiusState);
    final textFieldBorderRadius = ref.watch(textFieldBorderRadiusState);
    final outlinedButtonWidth = ref.watch(outlinedButtonWidthState);

    final inputDecorationTheme = InputDecorationTheme(
      outlineBorder: const BorderSide(width: 2),
      border: UnderlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(textFieldBorderRadius),
      ),
    );
    final textButtonTheme = TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonBorderRadius),
        ),
      ),
    );
    final elevatedButtonTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonBorderRadius),
        ),
      ),
    );
    final filledButtonTheme = FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonBorderRadius),
        ),
      ),
    );
    final outlinedButtonTheme = OutlinedButtonThemeData(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonBorderRadius),
          ),
        ),
        side: MaterialStateProperty.resolveWith(
          (states) {
            if (outlinedButtonWidth == 0) return BorderSide.none;
            if (states.contains(MaterialState.disabled)) {
              return BorderSide(width: outlinedButtonWidth, color: themeAppColor.borderColor);
            }
            return BorderSide(width: outlinedButtonWidth, color: themeAppColor.primaryColor);
          },
        ),
      ),
      // style: OutlinedButton.styleFrom(
      //   side: BorderSide(
      //     width: 2,
      //     color: themeAppColor.primaryColor,
      //   ),
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(buttonBorderRadius),
      //   ),
      // ),
    );
    final textTheme = const TextTheme();
    final iconButtonTheme = IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: themeAppColor.primaryColor,
      ),
    );

    return MaterialApp(
      title: 'Design token builder Demo',
      themeMode: brightness == Brightness.light ? ThemeMode.light : ThemeMode.dark,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          primary: themeAppColor.primaryColor,
          seedColor: themeAppColor.primaryColor,
          onPrimary: themeAppColor.onPrimaryColor,
        ),
        indicatorColor: themeAppColor.primaryColor,
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: themeAppColor.onPrimaryColor),
          backgroundColor: themeAppColor.primaryColor,
          foregroundColor: themeAppColor.onPrimaryColor,
        ),
        dropdownMenuTheme: DropdownMenuThemeData(
          textStyle: context.textTheme.bodyMedium?.copyWith(color: Colors.white),
        ),
        dividerTheme: DividerThemeData(
          color: themeAppColor.dividerColor,
        ),
        brightness: Brightness.light,
        textTheme: textTheme,
        inputDecorationTheme: inputDecorationTheme,
        textButtonTheme: textButtonTheme,
        elevatedButtonTheme: elevatedButtonTheme,
        filledButtonTheme: filledButtonTheme,
        outlinedButtonTheme: outlinedButtonTheme,
        iconButtonTheme: iconButtonTheme,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: themeAppColor.primaryColor,
        brightness: Brightness.dark,
        indicatorColor: themeAppColor.primaryColor,
        inputDecorationTheme: inputDecorationTheme,
        textButtonTheme: textButtonTheme,
        elevatedButtonTheme: elevatedButtonTheme,
        filledButtonTheme: filledButtonTheme,
        outlinedButtonTheme: outlinedButtonTheme,
        iconButtonTheme: iconButtonTheme,
      ),
      home: const Home(),
    );
  }
}

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  final TextEditingController _controllerFilled = TextEditingController();
  final TextEditingController _controllerOutlined = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final brightness = ref.watch(brightnessState);
    final colorSeed = ref.watch(themeAppState);
    final themeAppColor = ref.watch(themeAppState);
    final outlinedButtonWidth = ref.watch(outlinedButtonWidthState);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo'),
        centerTitle: true,
        flexibleSpace: Align(
          alignment: Alignment.bottomLeft,
          child: Row(
            children: [
              IconButton(
                hoverColor: themeAppColor.onPrimaryColor?.withOpacity(0.1),
                icon: Icon(
                  brightness == Brightness.light
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                  color: themeAppColor.onPrimaryColor,
                ),
                onPressed: () {
                  final newBrightness =
                      brightness == Brightness.light ? Brightness.dark : Brightness.light;
                  ref.read(brightnessState.notifier).state = newBrightness;
                },
              ),
              IconButton(
                hoverColor: themeAppColor.onPrimaryColor?.withOpacity(0.1),
                icon: Icon(
                  Icons.settings,
                  color: themeAppColor.onPrimaryColor,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChangeThemePage()),
                  );
                },
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: DropdownButton<String>(
              selectedItemBuilder: (context) => ref
                  .watch(appThemeColor)
                  .map(
                    (e) => Center(
                      child: Text(
                        e.label.toString(),
                        style: context.textTheme.bodyMedium
                            ?.copyWith(color: themeAppColor.onPrimaryColor),
                      ),
                    ),
                  )
                  .toList(),
              value: colorSeed.id,
              items: ref
                  .watch(appThemeColor)
                  .map(
                    (e) => DropdownMenuItem<String>(
                      value: e.id,
                      child: Text(
                        e.label.toString(),
                        style: context.textTheme.bodyMedium!.copyWith(
                          color: context.colorScheme.onBackground,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                final selectedTheme = ref.read(themeListProvider).firstWhere((e) => e.id == value);
                ref.read(themeAppState.notifier).state = selectedTheme;
              },
            ),
          ),
        ],
      ),
      body: ColoredBox(
        color: context.colorScheme.background,
        child: SingleChildScrollView(
          child: Column(
            children: [
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Default',
                            style: context.textTheme.titleMedium,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(onPressed: () {}, child: const Text('TextButton')),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FilledButton(onPressed: () {}, child: const Text('FilledButton')),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                              OutlinedButton(onPressed: () {}, child: const Text('OutlinedButton')),
                        ),
                        SliderTheme(
                          data: const SliderThemeData(
                              showValueIndicator: ShowValueIndicator.onlyForContinuous),
                          child: Slider(
                            min: 0,
                            max: 6,
                            value: outlinedButtonWidth,
                            label: "${outlinedButtonWidth.toInt()}",
                            onChanged: (double value) {
                              ref.read(outlinedButtonWidthState.notifier).state =
                                  value.roundToDouble();
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                              ElevatedButton(onPressed: () {}, child: const Text('ElevatedButton')),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Default',
                            style: context.textTheme.titleMedium,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(onPressed: null, child: const Text('TextButton')),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FilledButton(onPressed: null, child: const Text('FilledButton')),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                              OutlinedButton(onPressed: null, child: const Text('OutlinedButton')),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                              ElevatedButton(onPressed: null, child: const Text('ElevatedButton')),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Builder(builder: (context) {
                final borderRadius = ref.watch(buttonBorderRadiusState);
                return SliderTheme(
                  data: const SliderThemeData(
                      showValueIndicator: ShowValueIndicator.onlyForContinuous),
                  child: Slider(
                    min: 0,
                    max: 24,
                    value: borderRadius,
                    label: "${borderRadius.toInt()}",
                    onChanged: (double value) {
                      ref.read(buttonBorderRadiusState.notifier).state = value.roundToDouble();
                    },
                  ),
                );
              }),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Custom',
                          style: context.textTheme.titleMedium,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.redAccent,
                          ),
                          child: const Text('TextButton'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {},
                          child: const Text('FilledButton'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.green,
                          ),
                          onPressed: () {},
                          child: const Text('ElevatedButton'),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Custom',
                          style: context.textTheme.titleMedium,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                          onPressed: null,
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.redAccent,
                          ),
                          child: const Text('TextButton'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: null,
                          child: const Text('FilledButton'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: null,
                          child: const Text('ElevatedButton'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: textStyles(context).length,
                itemBuilder: (context, index) {
                  final textStyle = textStyles(context)[index];
                  return Text(
                    textStyle.debugLabel!.split(' ')[1],
                    style: textStyle.copyWith(color: context.colorScheme.onBackground),
                  );
                },
              ),
              const Divider(),
              Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(ref.read(textFieldBorderRadiusState)),
                    border: Border.all(
                      width: 2,
                      color: themeAppColor.borderColor,
                    ),
                  ),
                  child: const ProgressIndicators()),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(smallSpacing),
                      child: TextField(
                        controller: _controllerFilled,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _ClearButton(controller: _controllerFilled),
                          labelText: 'Filled',
                          hintText: 'hint text',
                          helperText: 'supporting text',
                          filled: true,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(smallSpacing),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: SizedBox(
                              child: TextField(
                                maxLength: 10,
                                maxLengthEnforcement: MaxLengthEnforcement.none,
                                controller: _controllerFilled,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.search),
                                  suffixIcon: _ClearButton(controller: _controllerFilled),
                                  labelText: 'Filled',
                                  hintText: 'hint text',
                                  helperText: 'supporting text',
                                  filled: true,
                                  errorText: 'error text',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: smallSpacing),
                          Flexible(
                            child: SizedBox(
                              child: TextField(
                                controller: _controllerFilled,
                                enabled: false,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.search),
                                  suffixIcon: _ClearButton(controller: _controllerFilled),
                                  labelText: 'Disabled',
                                  hintText: 'hint text',
                                  helperText: 'supporting text',
                                  filled: true,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Builder(builder: (context) {
                      final borderRadius = ref.read(textFieldBorderRadiusState);
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
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(smallSpacing),
                              child: TextField(
                                controller: _controllerOutlined,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.search),
                                  suffixIcon: _ClearButton(controller: _controllerOutlined),
                                  labelText: 'Outlined',
                                  hintText: 'hint text',
                                  helperText: 'supporting text',
                                ),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.all(smallSpacing),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: SizedBox(
                                          child: TextField(
                                            controller: _controllerOutlined,
                                            decoration: InputDecoration(
                                              prefixIcon: const Icon(Icons.search),
                                              suffixIcon:
                                                  _ClearButton(controller: _controllerOutlined),
                                              labelText: 'Outlined',
                                              hintText: 'hint text',
                                              helperText: 'supporting text',
                                              errorText: 'error text',
                                              filled: false,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: smallSpacing),
                                      Flexible(
                                        child: SizedBox(
                                          child: TextField(
                                            controller: _controllerOutlined,
                                            enabled: false,
                                            decoration: InputDecoration(
                                              prefixIcon: const Icon(Icons.search),
                                              suffixIcon:
                                                  _ClearButton(controller: _controllerOutlined),
                                              labelText: 'Disabled',
                                              hintText: 'hint text',
                                              helperText: 'supporting text',
                                              filled: true,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ])),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              Builder(builder: (context) {
                final borderRadius = ref.read(textFieldBorderRadiusState);
                return SliderTheme(
                  data: const SliderThemeData(
                      showValueIndicator: ShowValueIndicator.onlyForContinuous),
                  child: Slider(
                    min: 0,
                    max: 24,
                    value: borderRadius,
                    label: "${borderRadius.toInt()}",
                    onChanged: (double value) {
                      ref.read(textFieldBorderRadiusState.notifier).state = value.roundToDouble();
                    },
                  ),
                );
              }),
              const SizedBox(height: 150),
            ],
          ),
        ),
      ),
    );
  }
}

class _ClearButton extends StatelessWidget {
  const _ClearButton({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) => IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => controller.clear(),
      );
}

class ProgressIndicators extends StatefulWidget {
  const ProgressIndicators({super.key});

  @override
  State<ProgressIndicators> createState() => _ProgressIndicatorsState();
}

class _ProgressIndicatorsState extends State<ProgressIndicators> {
  bool playProgressIndicator = false;

  @override
  Widget build(BuildContext context) {
    final double? progressValue = playProgressIndicator ? null : 0.7;

    return Column(
      children: <Widget>[
        Row(
          children: [
            IconButton(
              isSelected: playProgressIndicator,
              selectedIcon: const Icon(Icons.pause),
              icon: const Icon(Icons.play_arrow),
              onPressed: () {
                setState(() {
                  playProgressIndicator = !playProgressIndicator;
                });
              },
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  rowDivider,
                  CircularProgressIndicator(
                    value: progressValue,
                  ),
                  rowDivider,
                  Expanded(
                    child: LinearProgressIndicator(
                      value: progressValue,
                    ),
                  ),
                  rowDivider,
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

List<TextStyle> textStyles(BuildContext context) => [
      context.textTheme.displayLarge!,
      context.textTheme.displayMedium!,
      context.textTheme.displaySmall!,
      context.textTheme.titleLarge!,
      context.textTheme.titleMedium!,
      context.textTheme.titleSmall!,
      context.textTheme.bodyLarge!,
      context.textTheme.bodyMedium!,
      context.textTheme.bodySmall!,
      context.textTheme.labelLarge!,
      context.textTheme.labelMedium!,
      context.textTheme.labelSmall!,
    ];
