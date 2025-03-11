import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

class CreateWheel extends StatefulWidget {
  const CreateWheel({super.key});

  @override
  State<CreateWheel> createState() => _CreateWheelState();
}

class _CreateWheelState extends State<CreateWheel> {
  StreamController<int> controller = StreamController<int>.broadcast(); // Use broadcast stream

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Fortune Wheel
            SizedBox(
              height: 300,
              width: 300,
              child: FortuneWheel(
                selected: controller.stream,
                items: const [
                  FortuneItem(child: Text('Sujal')),
                  FortuneItem(child: Text('Dharsh')),
                  FortuneItem(child: Text('Yash')),
                  FortuneItem(child: Text('Yash')),
                  FortuneItem(child: Text('Yash')),
                  FortuneItem(child: Text('Yash')),
                  FortuneItem(child: Text('Yash')),
                ],
              ),
            ),

            // Arrow Indicator
            Positioned(
              top: 10, // Adjust position as needed
              child: Icon(
                Icons.arrow_drop_down, // Downward arrow
                size: 40,
                color: Colors.red, // Customize color
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          int selectedIndex = Random().nextInt(7); // Random selection
          controller.add(selectedIndex);
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
