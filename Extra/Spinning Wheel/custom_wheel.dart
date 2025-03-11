import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

class CustomWheel extends StatefulWidget {
  const CustomWheel({super.key});

  @override
  State<CustomWheel> createState() => _CustomWheelState();
}

class _CustomWheelState extends State<CustomWheel> {
  StreamController<int> controller = StreamController<int>.broadcast();
  List<FortuneItem> wheelItems = [
    FortuneItem(child: Text('Yes'), style: FortuneItemStyle(color: Colors.green)),
    FortuneItem(child: Text('No'), style: FortuneItemStyle(color: Colors.red)),
  ];

    TextEditingController optionController = TextEditingController();
  Color selectedColor = Colors.blue;
  String selectedOption = "";

  void addOption() {
    if (optionController.text.isNotEmpty) {
      setState(() {
        wheelItems.add(
          FortuneItem(
            child: Text(optionController.text),
            style: FortuneItemStyle(color: selectedColor),
          ),
        );
        optionController.clear();
      });
    }
  }

  void editOption(int index) {
    TextEditingController editController = TextEditingController(text: (wheelItems[index].child as Text).data ?? "");
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Option'),
        content: TextField(
          controller: editController,
          decoration: const InputDecoration(hintText: 'Enter new option'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                wheelItems[index] = FortuneItem(
                  child: Text(editController.text),
                  style: wheelItems[index].style,
                );
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customizable Fortune Wheel')),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 300,
                    width: 300,
                    child: FortuneWheel(
                      selected: controller.stream,
                      items: wheelItems,
                      onFling: () {
                        int selectedIndex = Random().nextInt(wheelItems.length);
                        controller.add(selectedIndex);

                        // Delay setting selectedOption until the wheel animation completes
                        Future.delayed(const Duration(seconds: 2), () {
                          setState(() {
                            selectedOption = (wheelItems[selectedIndex].child as Text).data ?? "";
                          });
                        });
                      },

                    ),
                  ),
                  const Positioned(
                    top: 10,
                    child: Icon(
                      Icons.arrow_drop_down,
                      size: 40,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Selected Option: $selectedOption", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: optionController,
                    decoration: const InputDecoration(hintText: 'Enter Option'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.color_lens),
                  onPressed: () async {
                    Color? pickedColor = await showDialog(
                      context: context,
                      builder: (context) => ColorPickerDialog(initialColor: selectedColor),
                    );
                    if (pickedColor != null) {
                      setState(() {
                        selectedColor = pickedColor;
                      });
                    }
                  },
                ),
                ElevatedButton(onPressed: addOption, child: const Text('Add')),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: wheelItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text((wheelItems[index].child as Text).data ?? ""),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => editOption(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          int selectedIndex = Random().nextInt(wheelItems.length);
          controller.add(selectedIndex);

          // Delay updating selectedOption
          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              selectedOption = (wheelItems[selectedIndex].child as Text).data ?? "";
            });
          });
        },

        child: const Icon(Icons.play_arrow),
      ),
    );
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }
}

class ColorPickerDialog extends StatefulWidget {
  final Color initialColor;
  const ColorPickerDialog({required this.initialColor, super.key});

  @override
  _ColorPickerDialogState createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  Color selectedColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    selectedColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pick a Color'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            children: Colors.primaries.map((color) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedColor = color;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.all(4),
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: selectedColor == color
                        ? Border.all(width: 3, color: Colors.black)
                        : null,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, selectedColor),
          child: const Text('Select'),
        ),
      ],
    );
  }
}
