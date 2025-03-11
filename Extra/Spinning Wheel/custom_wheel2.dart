import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';


class Wheelpage extends StatefulWidget {
  const Wheelpage({super.key});

  @override
  State<Wheelpage> createState() => _WheelpageState();
}

class _WheelpageState extends State<Wheelpage> {

  StreamController<int> controller = StreamController<int>.broadcast();

  List<FortuneItem>wheelitem = [
    FortuneItem(child: Text('Yes'), style: FortuneItemStyle(color: Colors.red)),
    FortuneItem(child: Text('No'), style: FortuneItemStyle(color: Colors.green))
  ];

  String selectedOption = "";
  TextEditingController optioncontroller = TextEditingController();
  Color selectedColor = Colors.blue;
  bool showResult = false;

  void addOption (){
    if(optioncontroller.text.isNotEmpty){
      FocusScope.of(context).unfocus();
      setState(() {
        wheelitem.add(
          FortuneItem(child: Text(optioncontroller.text),
            style:FortuneItemStyle(color: selectedColor),
          ),
        );
        optioncontroller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wheel Decide ')),

      body: Column(
        children: [
          Expanded(child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 300,
                  width: 300,
                  child: FortuneWheel(
                    selected: controller.stream,
                    items: wheelitem,
                    onFling: () {
                      int selectindex = Random().nextInt(wheelitem.length);
                      controller.add(selectindex);

                      // Hide text initially for animation
                      setState(() {
                        showResult = false;
                        selectedOption = ""; // Clear old selection
                      });

                      Future.delayed(const Duration(seconds: 2), () {
                        setState(() {
                          selectedOption = (wheelitem[selectindex].child as Text).data ?? "";
                        });

                        // Delay to show fade-in effect
                        Future.delayed(const Duration(milliseconds: 500), () {
                          setState(() {
                            showResult = true; // Show with fade-in
                          });
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
          )),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 500), // Smooth fade-in effect
              opacity: showResult ? 1.0 : 0.0, // Fade effect
              child: Text(
                "Selected Option: $selectedOption",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ),
          ),



          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: optioncontroller,
                    decoration: InputDecoration(
                      hintText: 'Enter Option',
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
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
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      color: selectedColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                  ),
                ),
                SizedBox(width: 8), // Add spacing
                ElevatedButton(onPressed: addOption, child: Text("Add")),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: wheelitem.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text((wheelitem[index].child as Text).data ?? ""),
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
          int selectedIndex = Random().nextInt(wheelitem.length);
          controller.add(selectedIndex);

          setState(() {
            showResult = false;
            selectedOption = "";
          });

          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              selectedOption = (wheelitem[selectedIndex].child as Text).data ?? "";
            });

            Future.delayed(const Duration(milliseconds: 500), () {
              setState(() {
                showResult = true;
              });
            });
          });
        },
        child: const Icon(Icons.play_arrow),
      ),

    );
  }

  void editOption(int index) {
    TextEditingController editController = TextEditingController(
      text: (wheelitem[index].child as Text).data ?? "",
    );

    Color selectedItemColor = wheelitem[index].style?.color ?? Colors.black;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) => AlertDialog(
            title: const Text('Edit Option'),
            content: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: editController,
                    decoration: const InputDecoration(hintText: 'Enter new option'),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    Color? pickedColor = await showDialog(
                      context: context,
                      builder: (context) => ColorPickerDialog(initialColor: selectedItemColor),
                    );
                    if (pickedColor != null) {
                      setStateDialog(() {
                        selectedItemColor = pickedColor; // Update color in dialog
                      });
                    }
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: selectedItemColor, // Updated color applied here
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    wheelitem[index] = FortuneItem(
                      child: Text(editController.text),
                      style: FortuneItemStyle(
                        color: selectedItemColor, // Save selected color
                      ),
                    );
                  });
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          ),
        );
      },
    );
  }
}


class ColorPickerDialog extends StatefulWidget {
  final Color initialColor;
  const ColorPickerDialog({required this.initialColor, super.key});

  @override
  State<ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog>
{
  Color selectedColor = Colors.blue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedColor =widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Pick a Color"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            children: Colors.primaries.map((color)
            {
              return GestureDetector(
                onTap: (){
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
                    shape:BoxShape.circle,
                    border: selectedColor == color
                        ? Border.all(width: 3, color: Colors.black)
                        : null,
                  ),
                ),
              );
            }).toList(),
          )
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
