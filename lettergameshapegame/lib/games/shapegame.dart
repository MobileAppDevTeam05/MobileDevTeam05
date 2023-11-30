import 'dart:math';

import 'package:flutter/material.dart';

class ShapeGame extends StatefulWidget {
  const ShapeGame({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  // ignore: library_private_types_in_public_api
  _ShapeGameState createState() => _ShapeGameState();
}

// ignore: must_be_immutable
class ShapeButton extends StatelessWidget {
  int shapeID = -1;
  String imagePath = "";
  // ignore: library_private_types_in_public_api
  _ShapeGameState gameState = _ShapeGameState();

  // ignore: library_private_types_in_public_api
  ShapeButton(int shapeIDInp, _ShapeGameState gameContext, {Key? key})
      : super(key: key) {
    shapeID = shapeIDInp;
    gameState = gameContext;
    imagePath = gameState.getShapePath(shapeID);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        gameState.inputID = shapeID;
        gameState.checkInput();
      },
      child: Image.asset(
        imagePath, // Replace with your image asset path
        width: 50.0,
        height: 50.0,
        fit: BoxFit.contain,
      ),
    );
  }
}

class _ShapeGameState extends State<ShapeGame> {
  List<double> opacityValues = [0.2, 0.2]; // Initial opacity values

  //defining which id goes with what shape
  int triangle = 0;
  int square = 1;
  int circle = 2;
  int diamond = 3;

  String promptPath = "";
  int promptID = 0; //Initial prompt
  int inputID = 0; //Initial input
  int score = 0; //Initial score
  Random rand = Random();

  _ShapeGameState() {
    updatePrompt();
  }

  // Function to update the opacity value for a specific index
  void updateOpacity(int index, double newOpacity) {
    setState(() {
      opacityValues[index] = newOpacity;
    });
  }

  //Function to easily update our correctness feedback icons with a boolean
  void setFeedBackIconOcpacity(bool isCorrect) {
    if (isCorrect) {
      updateOpacity(0, 1);
      updateOpacity(1, 0.2);
    } else {
      updateOpacity(0, 0.2);
      updateOpacity(1, 1);
    }
  }

  //Function to select a random letter and set our prompt to it
  void updatePrompt() {
    int prevPromptID = promptID;
    promptID = rand.nextInt(4);
    promptPath = getShapePath(promptID);
    if (prevPromptID == promptID) {
      updatePrompt();
    }
  }

  //Function that defines which image path is associated with a shape ID
  String getShapePath(int shapeID) {
    switch (shapeID) {
      case 0:
        return 'lib/games/img/triangle.png';
      case 1:
        return 'lib/games/img/square.png';
      case 2:
        return 'lib/games/img/circle.png';
      case 3:
        return 'lib/games/img/diamond.png';
    }

    return 'err';
  }

  //Function to check if letter matches the prompt
  void checkInput() {
    if (promptID == inputID) {
      setFeedBackIconOcpacity(true);
      score++;
    } else {
      setFeedBackIconOcpacity(false);
      if (score >= 1) {
        score--;
      }
    }
    updatePrompt();
    inputID = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(children: [
                Expanded(
                  child: Text("Points: $score"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Exit'),
                ),
              ]),
              ColorFiltered(
                colorFilter:
                    const ColorFilter.mode(Colors.black, BlendMode.srcATop),
                child: Image.asset(promptPath,
                    key: Key(promptPath),
                    width: 50,
                    height: 50,
                    fit: BoxFit.contain),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Opacity(
                    opacity: opacityValues[0],
                    child: Image.asset(
                      'lib/games/img/greencheck.png',
                      width: 50.0,
                      height: 50.0,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Opacity(
                    opacity: opacityValues[1],
                    child: Image.asset(
                      'lib/games/img/redx.png',
                      width: 50.0,
                      height: 50.0,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShapeButton(triangle, this),
                  ShapeButton(square, this),
                  ShapeButton(circle, this),
                  ShapeButton(diamond, this),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
