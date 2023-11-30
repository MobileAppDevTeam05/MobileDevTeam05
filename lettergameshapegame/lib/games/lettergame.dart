import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LetterGame extends StatefulWidget {
  const LetterGame({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  // ignore: library_private_types_in_public_api
  _LetterGameState createState() => _LetterGameState();
}

class NoWhitespaceInputFormatter extends FilteringTextInputFormatter {
  NoWhitespaceInputFormatter() : super.deny(RegExp(r'\s'));
}

class _LetterGameState extends State<LetterGame> {
  List<double> opacityValues = [0.2, 0.2]; // Initial opacity values
  String prompt = "a"; //Initial prompt
  String input = ""; //Initial input
  int score = 0;
  Random rand = Random();
  TextEditingController textController =
      TextEditingController(); // Add a TextEditingController

  _LetterGameState() {
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
    String prevPrompt = prompt;
    prompt = String.fromCharCode('a'.codeUnitAt(0) + rand.nextInt(26));
    prompt = prompt.toUpperCase();
    if (prevPrompt == prompt) {
      updatePrompt();
    }
  }

  // Function to check if letter matches the prompt
  void checkInput() {
    if (prompt.isNotEmpty && input.isNotEmpty) {
      prompt = prompt.toUpperCase();
      input = input.toUpperCase();

      if (prompt.characters.characterAt(0) == input.characters.characterAt(0)) {
        // Do something when the input matches the prompt
        setFeedBackIconOcpacity(true);
        score++;
      } else {
        // Do something when the input does not match the prompt
        setFeedBackIconOcpacity(false);
        if (score >= 1) {
          score--;
        }
      }

      textController.clear();
      input = "";
      updatePrompt();
    }
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
              Text(
                prompt,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
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
              TextField(
                controller: textController, // Assign the controller
                maxLength: 1,
                inputFormatters: [NoWhitespaceInputFormatter()],
                decoration: const InputDecoration(
                  labelText: "What letter is above?",
                ),
                onChanged: (value) {
                  input = value;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  checkInput();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
