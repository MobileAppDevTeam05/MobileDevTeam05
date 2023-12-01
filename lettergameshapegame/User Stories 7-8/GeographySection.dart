import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

void main() {
  runApp(MaterialApp(
    home: WelcomeScreen(),
  ));
}

class ScoreManager {
  static const String keyUserScore = 'user_score';
  static const String keyHighestScore = 'highest_score';

  static Future<int> getUserScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(keyUserScore) ?? 0;
  }

  static Future<void> updateUserScore(int newScore) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(keyUserScore, newScore);
  }

  static Future<int> getHighestScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(keyHighestScore) ?? 0;
  }

  static Future<void> updateHighestScore(int newHighestScore) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(keyHighestScore, newHighestScore);
  }
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to Geography Quiz'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to the Geography Quiz!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GeographyQuestionScreen()),
                );
              },
              child: Text('Start Game'),
            ),
          ],
        ),
      ),
    );
  }
}

class GeographyQuestionScreen extends StatefulWidget {
  @override
  _GeographyQuestionScreenState createState() => _GeographyQuestionScreenState();
}

class _GeographyQuestionScreenState extends State<GeographyQuestionScreen> {
  final List<Map<String, dynamic>> questions = [
    {'question': 'Which planet is known as the "Blue Planet"?', 'correctAnswer': 'Earth', 'otherChoices': ['Mars', 'Venus']},
    {'question': 'In which country is the Great Barrier Reef located?', 'correctAnswer': 'Australia', 'otherChoices': ['Brazil', 'Thailand']},
    {'question': 'What is the largest desert in the world?', 'correctAnswer': 'Antarctica', 'otherChoices': ['Sahara', 'Gobi']},
    {'question': 'Which ocean is on the east coast of the United States?', 'correctAnswer': 'Atlantic Ocean', 'otherChoices': ['Pacific Ocean', 'Indian Ocean']},
    {'question': 'Name the largest island in the world.', 'correctAnswer': 'Greenland', 'otherChoices': ['Australia', 'Borneo']},
    {'question': 'Which mountain range separates Europe and Asia?', 'correctAnswer': 'Ural Mountains', 'otherChoices': ['Andes', 'Himalayas']},
    {'question': 'What is the capital of Canada?', 'correctAnswer': 'Ottawa', 'otherChoices': ['Toronto', 'Vancouver']},
    {'question': 'In which continent is the country of South Africa located?', 'correctAnswer': 'Africa', 'otherChoices': ['Asia', 'Europe']},
    {'question': 'Name the world\'s largest rainforest.', 'correctAnswer': 'Amazon Rainforest', 'otherChoices': ['Congo Rainforest', 'Borneo Rainforest']},
    {'question': 'Which sea is located between Europe and Africa?', 'correctAnswer': 'Mediterranean Sea', 'otherChoices': ['Dead Sea', 'Red Sea']},
    {'question': 'What is the capital city of China?', 'correctAnswer': 'Beijing', 'otherChoices': ['Shanghai', 'Guangzhou']},
    {'question': 'Which river is the longest in South America?', 'correctAnswer': 'Amazon River', 'otherChoices': ['Nile River', 'Mississippi River']},
    {'question': 'In which country would you find the pyramids of Giza?', 'correctAnswer': 'Egypt', 'otherChoices': ['Iraq', 'Iran']},
    {'question': 'What is the smallest state in the United States by land area?', 'correctAnswer': 'Rhode Island', 'otherChoices': ['Delaware', 'Connecticut']},
    {'question': 'Which continent is known as the "Land of Fire and Ice"?', 'correctAnswer': 'Iceland', 'otherChoices': ['Greenland', 'Antarctica']},
    {'question': 'Name the largest lake in Africa.', 'correctAnswer': 'Lake Victoria', 'otherChoices': ['Lake Tanganyika', 'Lake Malawi']},
    {'question': 'What is the capital of Russia?', 'correctAnswer': 'Moscow', 'otherChoices': ['St. Petersburg', 'Novosibirsk']},
    {'question': 'In which ocean would you find the Great Barrier Reef?', 'correctAnswer': 'Pacific Ocean', 'otherChoices': ['Indian Ocean', 'Atlantic Ocean']},
    {'question': 'Which country is both a continent and a country?', 'correctAnswer': 'Australia', 'otherChoices': ['Brazil', 'Canada']},
    {'question': 'What is the capital of India?', 'correctAnswer': 'New Delhi', 'otherChoices': ['Mumbai', 'Chennai']},
  ];

  int currentQuestionIndex = 0;

  @override
  Widget build(BuildContext context) {
    final randomQuestion = questions[currentQuestionIndex];
    final List<String> answerChoices = [randomQuestion['correctAnswer'], ...randomQuestion['otherChoices']!..shuffle()];

    return Scaffold(
      appBar: AppBar(
        title: Text('Geography Question'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              randomQuestion['question'],
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () => onAnswerSelected(answerChoices[0]),
                  child: Text(answerChoices[0]),
                ),
                ElevatedButton(
                  onPressed: () => onAnswerSelected(answerChoices[1]),
                  child: Text(answerChoices[1]),
                ),
                ElevatedButton(
                  onPressed: () => onAnswerSelected(answerChoices[2]),
                  child: Text(answerChoices[2]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void onAnswerSelected(String selectedAnswer) {
    bool isCorrect = selectedAnswer == questions[currentQuestionIndex]['correctAnswer'];

    if (isCorrect) {
      ScoreManager.updateUserScore(ScoreManager.getUserScore() + 1);
    }

    setState(() {
      currentQuestionIndex++;
    });

    if (currentQuestionIndex < questions.length) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GeographyResultScreen(isCorrect: isCorrect)),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EndSessionScreen()),
      );
    }
  }
}

class GeographyResultScreen extends StatelessWidget {
  final bool isCorrect;

  GeographyResultScreen({required this.isCorrect});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(isCorrect ? 'Correct!' : 'Incorrect!'),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GeographyQuestionScreen()),
                );
              },
              child: Text('Next Question'),
            ),
          ],
        ),
      ),
    );
  }
}

class EndSessionScreen extends StatefulWidget {
  @override
  _EndSessionScreenState createState() => _EndSessionScreenState();
}

class _EndSessionScreenState extends State<EndSessionScreen> {
  int userScore = 0;

  @override
  void initState() {
    super.initState();
    _loadUserScore();
  }

  Future<void> _loadUserScore() async {
    int score = await ScoreManager.getUserScore();
    setState(() {
      userScore = score;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('End of Session'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Your Score: $userScore'),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
              },
              child: Text('New Session'),
            ),
          ],
        ),
      ),
    );
  }
}
