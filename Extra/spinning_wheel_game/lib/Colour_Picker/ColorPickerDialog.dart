import 'package:flutter/material.dart';

class ColorPickerDialog extends StatefulWidget {
  final Color initialColor;
  const ColorPickerDialog({required this.initialColor, super.key});

  @override
  State<ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  Color selectedColor = Colors.blue;

  // Define light colors (lighter shades of primaries)
  final List<Color> lightColors = [

    Colors.blue,
    Colors.blue.shade100,
    Colors.blue.shade200,

    Colors.green,
    Colors.green.shade100,
    Colors.green.shade200,

    Colors.purple,
    Colors.purple.shade100,
    Colors.purple.shade200,

    Colors.orange,
    Colors.orange.shade100,
    Colors.orange.shade200,

    Colors.red,
    Colors.red.shade100,
    Colors.red.shade200,

    Colors.yellow,
    Colors.yellow.shade100,
    Colors.yellow.shade200,

    Colors.teal,
    Colors.teal.shade100,
    Colors.teal.shade200,

    Colors.cyan,
    Colors.cyan.shade100,
    Colors.cyan.shade200,

    Colors.indigo,
    Colors.indigo.shade100,
    Colors.indigo.shade200,

    Colors.brown,
    Colors.brown.shade100,
    Colors.brown.shade200,

    Colors.amber,
    Colors.amber.shade100,
    Colors.amber.shade200,

    Colors.lime,
    Colors.lime.shade100,
    Colors.lime.shade200,

    Colors.deepOrange,
    Colors.deepOrange.shade100,
    Colors.deepOrange.shade200,

    Colors.pink,
    Colors.pink.shade100,
    Colors.pink.shade200,

    Colors.purpleAccent,
    Colors.purpleAccent.shade100,
    Colors.purpleAccent.shade200,

    Colors.blueGrey,
    Colors.blueGrey.shade100,
    Colors.blueGrey.shade200,

    Colors.greenAccent,
    Colors.greenAccent.shade100,
    Colors.greenAccent.shade200,

    Colors.deepPurple,
    Colors.deepPurple.shade100,
    Colors.deepPurple.shade200,

    Colors.lightBlue,
    Colors.lightBlue.shade100,
    Colors.lightBlue.shade200,

    Colors.lightGreen,
    Colors.lightGreen.shade100,
    Colors.lightGreen.shade200,

    Colors.redAccent,
    Colors.redAccent.shade100,
    Colors.redAccent.shade200,

    Colors.orangeAccent,
    Colors.orangeAccent.shade100,
    Colors.orangeAccent.shade200,

    Colors.yellowAccent,
    Colors.yellowAccent.shade100,
    Colors.yellowAccent.shade200,

    Colors.tealAccent,
    Colors.tealAccent.shade100,
    Colors.tealAccent.shade200,
  ];



  @override
  void initState() {
    super.initState();
    selectedColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Pick a Color"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Display light color options
          Wrap(
            children: lightColors.map((color) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedColor = color;
                  });
                },
                child: Container(
                  margin: EdgeInsets.all(4),
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
