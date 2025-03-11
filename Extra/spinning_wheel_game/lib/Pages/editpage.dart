import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Colour_Picker/ColorPickerDialog.dart';
import '../Database/db_helper.dart';
class Editpage extends StatefulWidget {
  final List<FortuneItem> wheelitem;
  const Editpage({Key? key, required this.wheelitem}) : super(key: key);
  @override
  State<Editpage> createState() => _EditpageState();
}
class _EditpageState extends State<Editpage> {
  late List<FortuneItem> items;

/*  @override
  void initState() {
    super.initState();
    items = List.from(widget.wheelitem);
  }*/
  @override
  void initState() {
    super.initState();
    if (widget.wheelitem.isEmpty) {
      items = [
        FortuneItem(
          child: Text('Yes', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          style: FortuneItemStyle(color: Colors.green),
        ),
        FortuneItem(
          child: Text('No', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          style: FortuneItemStyle(color: Colors.red),
        ),
      ];
    } else {
      items = List.from(widget.wheelitem);
    }
  }

  void editOption(int index) {
    TextEditingController controller = TextEditingController(
      text: (items[index].child is Text) ? (items[index].child as Text).data ?? "" : "",
    );
    Color selectedColor = items[index].style?.color ?? Colors.black;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              title: Text('Edit Option', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          decoration: InputDecoration(
                            hintText: "Enter new option",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () async {
                          Color? pickedColor = await showDialog(
                            context: context,
                            builder: (context) => ColorPickerDialog(initialColor: selectedColor),
                          );
                          if (pickedColor != null) {
                            setStateDialog(() {
                              selectedColor = pickedColor;
                            });
                          }
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: selectedColor,
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                  onPressed: () {
                    setState(() {
                      items[index] = FortuneItem(
                        child: Text(
                          controller.text,
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        style: FortuneItemStyle(color: selectedColor),
                      );
                    });
                    Navigator.pop(context);
                  },
                  child: Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }


  void addOption() {
    TextEditingController newOptionController = TextEditingController();
    Color selectedColor = Colors.blue.shade100;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              title: Text('Add Option', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: newOptionController,
                          decoration: InputDecoration(
                            hintText: 'Enter option text',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () async {
                          Color? pickedColor = await showDialog(
                            context: context,
                            builder: (context) => ColorPickerDialog(initialColor: selectedColor),
                          );
                          if (pickedColor != null) {
                            setStateDialog(() {
                              selectedColor = pickedColor;
                            });
                          }
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: selectedColor,
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                  onPressed: () {
                    setState(() {
                      items.add(FortuneItem(
                        child: Text(
                          newOptionController.text,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Large font for new items
                        ),
                        style: FortuneItemStyle(color: selectedColor),
                      ));

                    });
                    Navigator.pop(context);
                  },
                  child: Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Option', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent.shade100,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 5,
              margin: EdgeInsets.symmetric(vertical: 4),
              child: Card(
                color: items[index].style?.color ?? Colors.white, // Set card background color
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  title: Text(
                    (items[index].child as Text).data ?? "",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white, // Ensure text contrasts with background
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.edit, color: Colors.black87), // Icon stays visible on different backgrounds
                    onPressed: () => editOption(index),
                  ),
                ),
              ),

            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: addOption,
        child: Icon(Icons.add, size: 28),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(12),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightBlueAccent.shade100, // Change to your preferred color
            foregroundColor: Colors.white, // Text color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(vertical: 16),
            elevation: 5, // Adds a shadow effect
            shadowColor: Colors.black.withOpacity(0.3),
          ),
          //onPressed: () => Navigator.pop(context, items),
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();

            // Convert items list to a format suitable for SharedPreferences
            List<String> savedItems = items.map((item) {
              return "${(item.child as Text).data}|${item.style?.color?.value ?? Colors.black.value}";
            }).toList();

            await prefs.setStringList("saved_wheel_options", savedItems);

            // Return the updated list to WheelPage
            Navigator.pop(context, items);
          },

          child: Text(
            "Save",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1),
          ),
        ),
      ),

    );
  }
}