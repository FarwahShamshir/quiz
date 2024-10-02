import 'package:quiz/quiz.dart';

class QuizBrain {
  int _questionIndex = 0;
  List<Quiz> _questionBank = [
    Quiz(questionText: 'Flutter is a framework?', answer: true),
    Quiz(questionText: 'Flutter uses Dart language?', answer: true),
    Quiz(questionText: 'Flutter uses Dart language?', answer: true),
    Quiz(questionText: 'Flutter is primarily used for web development?', answer: false),
    Quiz(questionText: 'State management is important in Flutter apps?', answer: true),
    Quiz(questionText: 'Flutter can only be used for mobile applications?', answer: false),
    Quiz(questionText: 'Flutter provides a widget-based architecture?', answer: true),
    Quiz(questionText: 'The "StatelessWidget" class is mutable?', answer: false),
    Quiz(questionText: 'Flutter supports both iOS and Android development?', answer: true),
    Quiz(questionText: 'Hot reload is a feature in Flutter?', answer: true),
    Quiz(questionText: 'Flutter applications cannot be built for desktop?', answer: false),
    Quiz(questionText: 'Dart is a strongly typed language?', answer: true),

    // Add 8 more questions here
  ];
  String getQuestion() {
    return _questionBank[_questionIndex].questionText;
  }
  bool getAnswer() {
    return _questionBank[_questionIndex].answer;
  }
  void nextQuestion() {
    if (_questionIndex < _questionBank.length - 1) {
      _questionIndex++;
    }
  }
  bool isFinished() {
    return _questionIndex >= _questionBank.length - 1;
  }
  void reset() {
    _questionIndex = 0;
  }
}
