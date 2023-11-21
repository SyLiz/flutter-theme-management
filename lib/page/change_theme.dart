import 'package:design_tokens_test/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const rowDivider = SizedBox(width: 20);
const colDivider = SizedBox(height: 10);
const tinySpacing = 3.0;
const smallSpacing = 10.0;
const double cardWidth = 115;
const double widthConstraint = 450;

class ChangeThemePage extends ConsumerStatefulWidget {
  const ChangeThemePage({super.key});

  @override
  ConsumerState createState() => _ChangeThemePageState();
}

class _ChangeThemePageState extends ConsumerState<ChangeThemePage> {
  @override
  Widget build(BuildContext context) {
    final borderRadius = ref.read(textFieldBorderRadiusState);
    final themeApp = ref.watch(themeAppState);
    final themeList = ref.watch(themeListProvider);
    final themeListNotifier = ref.read(themeListProvider.notifier);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Change Theme'),
          actions: [
            IconButton(
              onPressed: () {
                themeListNotifier.add(
                  AppThemeColor(
                    id: uuid.v4(),
                    label: Colors.black.toStringHEX(),
                    primaryColor: Colors.black,
                  ),
                );
              },
              icon: const Icon(Icons.add),
            ),
            rowDivider,
          ],
        ),
        body: Theme(
          data: Theme.of(context).copyWith(
              inputDecorationTheme: InputDecorationTheme(
            outlineBorder: BorderSide(
              width: 2,
              color: themeApp.borderColor,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: themeApp.borderColor,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          )),
          child: ListView(
            children: themeList.map((e) {
              final canSwipe = e.id != themeList.first.id && e.id != themeApp.id;
              return Dismissible(
                key: Key(e.id),
                background: Container(color: Colors.red),
                onDismissed:
                    canSwipe ? (_) => ref.read(themeListProvider.notifier).remove(e) : null,
                direction: !canSwipe ? DismissDirection.none : DismissDirection.endToStart,
                child: ExpansionTile(
                  title: Text(e.label.toString()),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (e.id == themeApp.id) const Text('Selected'),
                      rowDivider,
                      CircleAvatar(
                        backgroundColor: e.primaryColor,
                      ),
                    ],
                  ),
                  expandedAlignment: Alignment.centerLeft,
                  children: <Widget>[
                    AbsorbPointer(
                      absorbing: e.id == themeList.first.id,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Builder(builder: (context) {
                              final textEditingController = TextEditingController(text: e.label);
                              textEditingController.selection = TextSelection.fromPosition(
                                  TextPosition(offset: textEditingController.text.length));
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('Label : '),
                                  SizedBox(
                                    width: 240,
                                    child: TextField(
                                      controller: textEditingController,
                                      onSubmitted: (value) {
                                        var name = value;
                                        if (value.isEmpty) {
                                          name = e.primaryColor.toStringHEX();
                                        } else {
                                          name = textEditingController.text;
                                        }
                                        themeListNotifier.edit(e.copyWith(label: name));
                                      },
                                      decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                            onPressed: () {
                                              var name = textEditingController.text;
                                              if (textEditingController.text.isEmpty) {
                                                name = e.primaryColor.toStringHEX();
                                              } else {
                                                name = textEditingController.text;
                                              }
                                              themeListNotifier.edit(e.copyWith(label: name));
                                            },
                                            icon: const Icon(Icons.check)),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                          colDivider,
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Primary Color : ',
                                ),
                                CircleAvatar(
                                  backgroundColor: e.primaryColor,
                                  child: InkWell(
                                    customBorder: const CircleBorder(),
                                    onTap: () {
                                      Color pickerColor = e.primaryColor;

                                      // ValueChanged<Color> callback
                                      void changeColor(Color color) {
                                        pickerColor = color;
                                      }

                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Pick a color!'),
                                          content: SingleChildScrollView(
                                            child: ColorPicker(
                                              pickerColor: pickerColor,
                                              onColorChanged: changeColor,
                                            ),
                                          ),
                                          actions: <Widget>[
                                            FilledButton(
                                              child: const Text('OK'),
                                              onPressed: () {
                                                themeListNotifier.edit(e.copyWith(
                                                    primaryColor: pickerColor,
                                                    label: pickerColor.toStringHEX()));
                                                if (e.id == themeApp.id) {
                                                  final selectedTheme = ref
                                                      .read(themeListProvider)
                                                      .firstWhere((element) => element.id == e.id);
                                                  ref.read(themeAppState.notifier).state =
                                                      selectedTheme;
                                                }
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          colDivider,
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'onPrimary Color : ',
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(width: 1, color: themeApp.borderColor)),
                                  child: CircleAvatar(
                                    backgroundColor: e.onPrimaryColor ?? Colors.black,
                                    child: InkWell(
                                      customBorder: const CircleBorder(),
                                      onTap: () {
                                        Color? pickerColor = e.onPrimaryColor;
                                        showColorPickerDialog(context, pickerColor: pickerColor,
                                            onColorChanged: (Color color) {
                                          pickerColor = color;
                                        }, onPressed: () {
                                          themeListNotifier.edit(
                                            e.copyWith(
                                              onPrimaryColor: pickerColor,
                                            ),
                                          );
                                          if (e.id == themeApp.id) {
                                            final selectedTheme = ref
                                                .read(themeListProvider)
                                                .firstWhere((element) => element.id == e.id);
                                            ref.read(themeAppState.notifier).state = selectedTheme;
                                          }
                                          Navigator.of(context).pop();
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          colDivider,
                        ],
                      ),
                    )
                  ],
                ),
              );
            }).toList(),
          ),
        ));
  }

  Future<dynamic> showColorPickerDialog(BuildContext context,
      {Color? pickerColor,
      required void Function(Color color) onColorChanged,
      required void Function() onPressed}) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick a color!'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: pickerColor ?? Colors.black,
            onColorChanged: onColorChanged,
          ),
        ),
        actions: <Widget>[
          FilledButton(
            onPressed: onPressed,
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

extension MyColor on Color {
  String toStringHEX() {
    return '#${value.toRadixString(16).padLeft(6, '0')}';
  }
}
