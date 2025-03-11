import 'dart:async';
import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spinning_wheel_game/Pages/wheel_options.dart';
import '../Database/db_helper.dart';
import 'customdrawer.dart';
import 'editpage.dart';


class Wheelpage extends StatefulWidget {
  const Wheelpage({super.key});

  @override
  State<Wheelpage> createState() => _WheelpageState();
}

class _WheelpageState extends State<Wheelpage> {
  StreamController<int> controller = StreamController<int>.broadcast();
  late ConfettiController confettiController;
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  List<FortuneItem> currentWheelItems = [];
  String selectedOption = "";
  Color? wheelBackgroundColor;
  bool showResult = false;
  bool isSpinning = false;
  String selectedWheel = "Yes/No"; // Default wheel

  @override
  void initState() {
    super.initState();
    confettiController = ConfettiController(duration: Duration(seconds: 2));
    selectedWheel = "Yes/No"; // Ensure default is Yes/No
    _loadSelectedWheel();
  }

  @override
  void dispose() {
    confettiController.dispose();
    controller.close();
    super.dispose();
  }

  Future<void> _loadSelectedWheel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      String wheelName = prefs.getString('selectedWheel') ?? "Yes/No";  // Load from SharedPreferences, default to "Yes/No"

    setState(() {
      selectedWheel = wheelName;
    });

    // Load wheel items from SQLite or default options
    List<Map<String, dynamic>> savedWheelItems = await _databaseHelper.getWheelOptions(selectedWheel);

    setState(() {
      if (savedWheelItems.isNotEmpty) {
        currentWheelItems = savedWheelItems.map((item) {
          return FortuneItem(
            child: Text(
              item['label'],
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            style: FortuneItemStyle(color: Color(item['color'])),
          );
        }).toList();
      } else {
        // Fallback to default options if database is empty
        currentWheelItems = wheelOptions[selectedWheel]!.map((item) {
          return FortuneItem(
            child: Text(
              item['label'],
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            style: FortuneItemStyle(color: item['color']),
          );
        }).toList();
      }
    });
  }

  // Save selected wheel to SharedPreferences
  Future<void> _saveToSharedPreferences(String wheelName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedWheel', wheelName);  // Store selected wheel name
  }

  // Save selected wheel options to SQLite
  Future<void> _saveSelectedWheel(String wheelName, List<FortuneItem> items) async {
    await _databaseHelper.deleteWheelOptions(wheelName);
    for (var item in items) {
      await _databaseHelper.insertWheelOption(
        wheelName,
        (item.child as Text).data!,
        item.style!.color!,
      );
    }
  }

  // When changing wheel, save the selection to both SharedPreferences and SQLite
  void changeWheel(String wheelName) {
    if (wheelOptions.containsKey(wheelName)) {
      List<FortuneItem> newWheelItems = wheelOptions[wheelName]!
          .map((item) => FortuneItem(
        child: Text(
          item['label'],
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        style: FortuneItemStyle(color: item['color']),
      ))
          .toList();

      if (newWheelItems.length >= 2) {
        setState(() {
          selectedWheel = wheelName;
          currentWheelItems = newWheelItems;
        });

        // Save to both SharedPreferences and SQLite
        _saveToSharedPreferences(wheelName);  // Save to SharedPreferences
        _saveSelectedWheel(wheelName, newWheelItems);  // Save to SQLite
      } else {
        print("❌ Error: Selected wheel '$wheelName' has insufficient items.");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Selected wheel must have at least 2 items!")),
        );
      }
    } else {
      print("❌ Error: Wheel '$wheelName' not found in wheelOptions.");
    }
  }

  void spinWheel() {
    int selectedIndex = Random().nextInt(currentWheelItems.length);
    controller.add(selectedIndex);
    setState(() {
      isSpinning = true;
      showResult = false;
      selectedOption = "";
      wheelBackgroundColor = null;
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isSpinning = false;
      });
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          selectedOption = (currentWheelItems[selectedIndex].child as Text).data ?? "";
          wheelBackgroundColor = currentWheelItems[selectedIndex].style!.color;
          showResult = true;
        });

        confettiController.play(); // Start confetti when the result appears
      });
    });
  }

  /*void changeWheel(String wheelName) {
    if (wheelOptions.containsKey(wheelName)) {
      List<FortuneItem> newWheelItems = wheelOptions[wheelName]!
          .map((item) => FortuneItem(
        child: Text(
          item['label'],
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Consistent font size
        ),
        style: FortuneItemStyle(color: item['color']),
      ))
          .toList();

      if (newWheelItems.length >= 2) {
        setState(() {
          selectedWheel = wheelName;
          currentWheelItems = newWheelItems;
        });

        _saveSelectedWheel(wheelName, newWheelItems);
      } else {
        print("❌ Error: Selected wheel '$wheelName' has insufficient items.");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Selected wheel must have at least 2 items!")),
        );
      }
    } else {
      print("❌ Error: Wheel '$wheelName' not found in wheelOptions.");
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Wheel Decide', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            centerTitle: true,
            backgroundColor: Colors.lightBlueAccent.shade100,
          ),
          drawer: CustomDrawer(onWheelSelected: changeWheel, selectedWheel: selectedWheel),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: isSpinning
                  ? RadialGradient(
                colors: [Colors.white, Colors.black],
                stops: [0.0, 1.0],
                center: Alignment.center,
                radius: 1.0,
              )
                  : null,
              color: isSpinning ? null : wheelBackgroundColor,
              image: DecorationImage(
                image: AssetImage('assets/img.png'),
                fit: BoxFit.cover,
                opacity: 0.1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black38,
                              blurRadius: 15,
                              spreadRadius: 8,
                            ),
                          ],
                        ),
                        child: SizedBox(
                          height: 300,
                          width: 300,
                          child: FortuneWheel(
                            selected: controller.stream,
                            items: currentWheelItems.isEmpty ? [
                              FortuneItem(child: Text("Yes"), style: FortuneItemStyle(color: Colors.red.shade100)),
                              FortuneItem(child: Text("No"), style: FortuneItemStyle(color: Colors.green.shade100))
                            ] : currentWheelItems,  // Fallback items to prevent crash
                            physics: CircularPanPhysics(
                              duration: const Duration(seconds: 2),
                              curve: Curves.decelerate,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: spinWheel,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                          child: Icon(Icons.refresh, color: Colors.black, size: 30),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50),
                AnimatedOpacity(
                  duration: Duration(milliseconds: 500),
                  opacity: showResult ? 1.0 : 0.0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Text(
                        /*Selected Option: */ "$selectedOption",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        ConfettiWidget(
          confettiController: confettiController,
          blastDirectionality: BlastDirectionality.explosive,
          blastDirection: -pi / 2,
          emissionFrequency: 0.02,
          numberOfParticles: 80,
          gravity: 0.1,
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20, right: 20),
            child: FloatingActionButton(
              onPressed: () async {
                List<FortuneItem>? updatedItems = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Editpage(wheelitem: currentWheelItems),
                  ),
                );

                if (updatedItems != null) {
                  setState(() {
                    currentWheelItems = updatedItems;
                  });
                }
              },
              child: Icon(Icons.edit, size: 30),
              backgroundColor: Colors.lightBlueAccent.shade100,
            ),
          ),
        ),
      ],

    );
  }
}

class CustomDrawer extends StatelessWidget {
  final Function(String) onWheelSelected;
  final String selectedWheel;

  const CustomDrawer({super.key, required this.onWheelSelected, required this.selectedWheel});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          SizedBox(
            height: 100,
            child:  DrawerHeader(
              child: Text(
                'Select a Wheel',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
              decoration: BoxDecoration(color: Colors.lightBlueAccent.shade100),
            ),
          ),

          Expanded(
            child: ListView(
              children: wheelOptions.keys.map((wheelName) {
                return ListTile(
                  leading: _buildWheelPreview(wheelOptions[wheelName]!),
                  title: Text(
                    wheelName,
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: selectedWheel == wheelName ? FontWeight.bold : FontWeight.normal,
                      color: selectedWheel == wheelName ? Colors.blue : Colors.black,
                    ),
                  ),
                  tileColor: selectedWheel == wheelName ? Colors.blue.shade100 : null,
                  onTap: () {
                    onWheelSelected(wheelName);
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // Generates a small preview of the wheel using colors
  Widget _buildWheelPreview(List<Map<String, dynamic>> options) {
    return CircleAvatar(
      radius: 25,
      child: Stack(
        children: options.asMap().entries.map((entry) {
          double startAngle = (entry.key / options.length) * 360;
          return Positioned.fill(
            child: CustomPaint(
              painter: _WheelSlicePainter(entry.value['color'], startAngle, 360 / options.length),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// Custom Painter to create a small wheel preview
class _WheelSlicePainter extends CustomPainter {
  final Color color;
  final double startAngle;
  final double sweepAngle;

  _WheelSlicePainter(this.color, this.startAngle, this.sweepAngle);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final rect = Rect.fromCircle(center: size.center(Offset.zero), radius: size.width / 2);
    canvas.drawArc(rect, startAngle * 3.1416 / 180, sweepAngle * 3.1416 / 180, true, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
