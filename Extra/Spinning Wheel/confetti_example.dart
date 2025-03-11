import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class ConfettiExample extends StatefulWidget {
  const ConfettiExample({super.key});

  @override
  State<ConfettiExample> createState() => _ConfettiExampleState();
}

class _ConfettiExampleState extends State<ConfettiExample>
{
  final _controller = ConfettiController();
  bool isPlaying = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Scaffold(
          appBar: AppBar(title: Text("Confetti_Example"),),
          body: Center(
            child: MaterialButton(
              onPressed: (){
                if(isPlaying)
                {
                  _controller.stop();
                }
                else
                  {
                    _controller.play();
                  }
                isPlaying = !isPlaying;
              },
              child: Text("Party Time"),
              color: Colors.deepPurple[200],
            ),
          ),
        ),
        ConfettiWidget(
          confettiController: _controller,
          blastDirection: -pi/2,
          colors: [
            Colors.deepPurple,
            Colors.pink,
            Colors.redAccent
          ],
          gravity: 0.01,
          emissionFrequency: 0.1,

        )

      ],
    );
  }
}
