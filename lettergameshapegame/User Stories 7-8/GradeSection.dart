import 'package:flutter/material.dart';

class GameSection {
  String sectionName;
  int highestScore;
  double overallGrade;

  GameSection({required this.sectionName, required this.highestScore, required this.overallGrade});
}

class HighScoreScreen extends StatefulWidget {
  final List<GameSection> gameSections;

  HighScoreScreen({required this.gameSections});

  @override
  _HighScoreScreenState createState() => _HighScoreScreenState();
}

class _HighScoreScreenState extends State<HighScoreScreen> {
  String selectedSection = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedSection.isNotEmpty ? '$selectedSection Scores' : 'Select a Topic'),
      ),
      body: selectedSection.isNotEmpty ? buildSectionScores() : buildSectionSelection(),
    );
  }

  Widget buildSectionSelection() {
    return ListView.builder(
      itemCount: widget.gameSections.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(widget.gameSections[index].sectionName),
          onTap: () {
            setState(() {
              selectedSection = widget.gameSections[index].sectionName;
            });
          },
        );
      },
    );
  }

  Widget buildSectionScores() {
    final selectedGameSection = widget.gameSections.firstWhere(
      (section) => section.sectionName == selectedSection,
    );

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Grade: ${selectedGameSection.overallGrade.toStringAsFixed(2)}'),
          Text('Highest Score: ${selectedGameSection.highestScore}'),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                selectedSection = '';
              });
            },
            child: Text('Return to Section Selection'),
          ),
          ElevatedButton(
            onPressed: () {
              // Navigate to the homepage or handle as needed
              Navigator.pop(context);
            },
            child: Text('Return to Homepage'),
          ),
        ],
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final String sectionName;
  final int userScore; // User's score for the section
  final int highestScore; // Highest score for the section
  final int totalQuestions; // Total questions in the section

  ResultScreen({
    required this.sectionName,
    required this.userScore,
    required this.highestScore,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    double overallGrade = userScore / totalQuestions;

    // Update the corresponding GameSection instance
    GameSection updatedGameSection = GameSection(
      sectionName: sectionName,
      highestScore: userScore > highestScore ? userScore : highestScore,
      overallGrade: overallGrade,
    );

    // Replace the existing GameSection with the updated one
    List<GameSection> updatedGameSections = List.from(HighScoreManager.gameSections);
    int sectionIndex = updatedGameSections.indexWhere((section) => section.sectionName == sectionName);
    if (sectionIndex != -1) {
      updatedGameSections[sectionIndex] = updatedGameSection;
    }

    // Pass the updated game sections to HighScoreScreen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HighScoreScreen(gameSections: updatedGameSections),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Result'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Section: $sectionName'),
            Text('Your Score: $userScore / $totalQuestions'),
            ElevatedButton(
              onPressed: () {
                // Navigate to the high score screen with the updated information
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HighScoreScreen(gameSections: updatedGameSections),
                  ),
                );
              },
              child: Text('View High Scores'),
            ),
          ],
        ),
      ),
    );
  }
}

class HighScoreManager {
  // A placeholder for the initial list of game sections
  static List<GameSection> gameSections = [
    GameSection(sectionName: 'Geography', highestScore: 0, overallGrade: 0),
    GameSection(sectionName: 'Letter Matching', highestScore: 0, overallGrade: 0),
    GameSection(sectionName: 'Shape Matching', highestScore: 0, overallGrade: 0),
    GameSection(sectionName: 'Basic Math', highestScore: 0, overallGrade: 0),
    GameSection(sectionName: 'Spelling', highestScore: 0, overallGrade: 0),
    GameSection(sectionName: 'History', highestScore: 0, overallGrade: 0),
  ];
}

void main() {
  runApp(MaterialApp(
    home: HighScoreScreen(gameSections: HighScoreManager.gameSections),
  ));
}
