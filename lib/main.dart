import 'package:flutter/material.dart';
import 'quiz_brain.dart';

QuizBrain quizBrain = QuizBrain();

void main() => runApp(QuizApp());

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.blueGrey)),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.blueGrey, // Button text color
            side: BorderSide(color: Colors.blueGrey, width: 2.0), // Button border
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0), // Increased button size
            textStyle: TextStyle(fontSize: 18.0), // Increased text size
          ),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.black,
        textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.blueGrey)),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.blueGrey,
            side: BorderSide(color: Colors.blueGrey, width: 2.0),
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
            textStyle: TextStyle(fontSize: 18.0),
          ),
        ),
      ),
      themeMode: ThemeMode.system,
      home: SplashScreen(), // Start with the SplashScreen
    );
  }
}

// Splash Screen Widget
class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Quiz App'),
      ),
      body: Center(
        child: OutlinedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => QuizPage()),
            );
          },
          child: Text('Start Quiz'),
        ),
      ),
    );
  }
}

// Quiz Page Widget
class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Icon> scoreKeeper = [];
  int score = 0;
  bool isQuizStarted = false;
  int timer = 5;

  void checkAnswer(bool userPickedAnswer) {
    bool correctAnswer = quizBrain.getAnswer();
    setState(() {
      if (correctAnswer == userPickedAnswer) {
        scoreKeeper.add(Icon(Icons.check, color: Colors.green));
        score++;
      } else {
        scoreKeeper.add(Icon(Icons.close, color: Colors.red));
      }
      if (quizBrain.isFinished()) {
        showResult();
      } else {
        quizBrain.nextQuestion();
        timer = 5;
        startTimer();
      }
    });
  }

  void startQuiz() {
    setState(() {
      isQuizStarted = true;
      startTimer();
    });
  }

  void startTimer() {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        if (timer > 0) {
          timer--;
          startTimer();
        } else {
          checkAnswer(false); // Timeout, move to next question
        }
      });
    });
  }

  void showResult() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Quiz Completed!"),
          content: Text("Your score is $score/10"),
          actions: [
            TextButton(
              child: Text("Restart"),
              onPressed: () {
                setState(() {
                  quizBrain.reset();
                  scoreKeeper.clear();
                  score = 0;
                  timer = 5;
                  isQuizStarted = false;
                });
                Navigator.of(context).pop(); // Close the dialog

                // Navigate back to SplashScreen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SplashScreen()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: isQuizStarted
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Time Left: $timer seconds',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Center(
                child: Text(
                  quizBrain.getQuestion(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton(
                      child: Text('True'),
                      onPressed: () {
                        checkAnswer(true);
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      child: Text('False'),
                      onPressed: () {
                        checkAnswer(false);
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Wrap(
              spacing: 4.0,
              children: scoreKeeper,
            ),
          ],
        )
            : Center(
          child: OutlinedButton(
            onPressed: startQuiz,
            child: Text('Start Quiz'),
          ),
        ),
      ),
    );
  }
}
