import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const String GUESS_BUTTON_TEXT = 'Guess!';
  static const String RESET_BUTTON_TEXT = 'Reset!';

  final TextEditingController controller = TextEditingController();
  final TextEditingController cardController = TextEditingController();

  int numberOfTries = 0;

  // value received from the user input
  int? valueReceived;

  // random number you have to guess
  int randomNumberToBeGuessed = Random().nextInt(99) + 1;

  bool isStatusTextVisible = false;

  // variable that tells if dialog should show or not
  bool isPopUpAvailable = false;

  // variable that tells if reset button appears
  bool isReset = false;
  bool isTextFieldEnabled = true;

  String hintText = '';

  // the elevated button insside the card can be either guess! nor reset!
  String cardButtonText = GUESS_BUTTON_TEXT;
  String? errorText;

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
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/leaderboard');
                },
                child: const Text('go to the leader board'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // this function checks if the value inputted is correct and then compares it with the one that has to be guessed
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

    numberOfTries++;

    controller.clear();
  }

  // this function shows game state after clicking OK in dialog
  void showGameState(BuildContext context) {
    resetGame(context);

    isStatusTextVisible = true;
    isTextFieldEnabled = false;
    isReset = true;
    cardButtonText = RESET_BUTTON_TEXT;
  }

  // this function resets the game after clicking Try again in dialog
  void resetGame(BuildContext context) {
    Navigator.of(context).pop();
    isPopUpAvailable = false;
    randomNumberToBeGuessed = Random().nextInt(99) + 1;


    String playerName = cardController.text;
    cardController.clear();

    savePlayerRecord(playerName, numberOfTries);

    numberOfTries = 0;
    isStatusTextVisible = false;
  }

  // this functions shows the dialog
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
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                child: TextField(
                  controller: cardController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: 'enter your name',
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      resetGame(context);
                    });
                  },
                  child: const Text('Try again!'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      showGameState(context);
                    });
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

  // this function sets reset mode
  void setReset() {
    if (isReset) {
      isStatusTextVisible = false;
      isTextFieldEnabled = true;
      isReset = false;
      errorText = null;
    }
  }

  // this function does the game logic and runs it
  void gameLogic() {
    checkValue();
    if (isPopUpAvailable) {
      FocusScope.of(context).unfocus();
      showPopUp();
    }

    setReset();

    cardButtonText = GUESS_BUTTON_TEXT;
  }

  void savePlayerRecord(String name, int score) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> leaderboardList = prefs.getStringList("leaderboard") ?? [];
    leaderboardList.add('$name $score');

    await prefs.setStringList('leaderboard', leaderboardList);
  }
}