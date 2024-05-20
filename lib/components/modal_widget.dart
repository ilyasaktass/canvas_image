import 'package:flutter/material.dart';
import 'package:canvas_image/screens/canvas/models/menu_selected_items.dart';

class CustomModal extends StatelessWidget {
  final double top;
  final double left;
  final double right;
  final double height;
  final List<MenuSelectedItems> items;
  final Function(String, bool) onItemSelect;

  const CustomModal({
    super.key,
    required this.top,
    required this.left,
    required this.right,
    required this.height,
    required this.items,
    required this.onItemSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: top,
          left: left,
          right: right,
          child: Material(
            color: Colors.transparent,
            child: Container(
              height: height,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Özellikleri Seçin'),
                  Expanded(
                    child: ListView(
                      children: [
                        ...items.where((item) => item.name != 'undo_redo' && item.name != 'alignmentTools' && item.name != 'colors').map((item) {
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return CheckboxListTile(
                                title: item.icon,
                                value: item.show,
                                onChanged: (bool? value) {
                                  setState(() {
                                    item.show = value ?? false;
                                  });
                                  onItemSelect(item.name, item.show);
                                },
                              );
                            },
                          );
                        }),
                        StatefulBuilder(
                          builder: (context, setState) {
                            return CheckboxListTile(
                              title: items.firstWhere((item) => item.name == 'undo_redo').icon,
                              value: items.firstWhere((item) => item.name == 'undo_redo').show,
                              onChanged: (bool? value) {
                                setState(() {
                                  final show = value ?? false;
                                  items.firstWhere((item) => item.name == 'undo_redo').show = show;
                                });
                                onItemSelect('undo_redo', items.firstWhere((item) => item.name == 'undo_redo').show);
                              },
                            );
                          },
                        ),
                        StatefulBuilder(
                          builder: (context, setState) {
                            return CheckboxListTile(
                              title: items.firstWhere((item) => item.name == 'alignmentTools').icon,
                              value: items.firstWhere((item) => item.name == 'alignmentTools').show,
                              onChanged: (bool? value) {
                                setState(() {
                                  final show = value ?? false;
                                  items.firstWhere((item) => item.name == 'alignmentTools').show = show;
                                });
                                onItemSelect('alignmentTools', items.firstWhere((item) => item.name == 'alignmentTools').show);
                              },
                            );
                          },
                        ),
                        StatefulBuilder(
                          builder: (context, setState) {
                            return CheckboxListTile(
                              title: items.firstWhere((item) => item.name == 'colors').icon,
                              value: items.firstWhere((item) => item.name == 'colors').show,
                              onChanged: (bool? value) {
                                setState(() {
                                  final show = value ?? false;
                                  items.firstWhere((item) => item.name == 'colors').show = show;
                                });
                                onItemSelect('colors', items.firstWhere((item) => item.name == 'colors').show);
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Tamam'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
