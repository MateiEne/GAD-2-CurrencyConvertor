import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const RandomNumberGuesser());
}

class RandomNumberGuesser extends StatelessWidget {
  const RandomNumberGuesser({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController controller = TextEditingController();

  int? valueReceived;
  int randomNumberToBeGuessed = Random().nextInt(99) + 1;

  bool isStatusTextVisible = false;
  bool isPopUpAvailable = false;
  bool isReset = false;
  bool isTextFieldEnabled = true;

  String hintText = '';
  String cardButtonText = 'Guess!';
  String? errorText;

  void checkValue() {
    if (controller.text.isEmpty) {
      isStatusTextVisible = false;
      errorText = 'Please enter a number';
      return;
    }

    valueReceived = int.tryParse(controller.text);

    if (valueReceived == null) {
      errorText = 'This is not a number';
      isStatusTextVisible = false;
      return;
    }

    isStatusTextVisible = true;
    errorText = null;

    if (valueReceived! < randomNumberToBeGuessed) {
      hintText = 'Try higher!';
    } else if (valueReceived! > randomNumberToBeGuessed) {
      hintText = 'Try lower!';
    } else {
      hintText = 'You guessed it!';
      isPopUpAvailable = true;
    }

    controller.clear();
  }

  void showGameState(BuildContext context) {
    Navigator.of(context).pop();
    isPopUpAvailable = false;
    randomNumberToBeGuessed = Random().nextInt(99) + 1;
    isTextFieldEnabled = false;
    isReset = true;
    cardButtonText = 'Reset!';
  }

  void resetGame(BuildContext context) {
    Navigator.of(context).pop();
    isPopUpAvailable = false;
    isStatusTextVisible = false;
    randomNumberToBeGuessed = Random().nextInt(99) + 1;
  }

  void showPopUp() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('You guessed it!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'It was $randomNumberToBeGuessed',
              ),
            ],
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    resetGame(context);
                  },
                  child: const Text('Try again!'),
                ),
                TextButton(
                  onPressed: () {
                    showGameState(context);
                  },
                  child: const Text('OK'),
                )
              ],
            )
          ],
        );
      },
    );
  }

  void checkReset() {
    if (isReset) {
      isStatusTextVisible = false;
      isTextFieldEnabled = true;
      isReset = false;
     }
  }

  void gameLogic() {
    checkValue();
    if (isPopUpAvailable) {
      showPopUp();
    }

    checkReset();

    cardButtonText = 'Guess!';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Guess my number'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
          child: Column(
            children: <Widget>[
              const Text(
                'I am thinking of a number between 1 and 100',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                ),
                textAlign: TextAlign.center,
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                child: Text(
                  "It's your turn to guess my number!",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Visibility(
                visible: isStatusTextVisible,
                child: Column(
                  children: [
                    Text(
                      'You tried ${valueReceived.toString()}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 28,
                      ),
                    ),
                    Text(
                      ' $hintText',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 28,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                child: Card(
                  elevation: 24.0,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.88,
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          const Expanded(
                            flex: 2,
                            child: Text(
                              'Try a number!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 32.0,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: TextField(
                              enabled: isTextFieldEnabled,
                              controller: controller,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                hintText: 'Enter a number',
                                errorText: errorText,
                              ),
                              onSubmitted: (String? value) {
                                setState(() {
                                  gameLogic();
                                });
                              },
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              print('$randomNumberToBeGuessed');

                              setState(() {
                                gameLogic();
                              });
                            },
                            child: Text(
                              cardButtonText,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
