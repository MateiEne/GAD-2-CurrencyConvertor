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

  bool isHintTextVisible = false;

  int randomNumberToBeGuessed = Random().nextInt(99) + 1;

  String hintText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Guess my number'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
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
              child: Column(
                children: [
                  Text(
                    'You tried ${valueReceived.toString()}',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 28,
                    ),
                  ),
                  Text(
                    ' $hintText',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 28,
                    ),
                  ),
                ],
              ),
              visible: isHintTextVisible,
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
                            controller: controller,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: 'Enter a number',
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (controller.text.isEmpty) {
                                return;
                              }

                              valueReceived = int.tryParse(controller.text);

                              if (valueReceived == null) {
                                print('not a number');
                                return;
                              }

                              isHintTextVisible = true;

                              if (valueReceived! < randomNumberToBeGuessed) {
                                print('try higher');
                                hintText = 'Try higher!';
                              } else if (valueReceived! >
                                  randomNumberToBeGuessed) {
                                hintText = 'Try lower!';
                                print('try lower');
                              } else {
                                hintText = 'You guessed it!';
                                print('You guessed it');
                              }
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.grey),
                          ),
                          child: const Text(
                            'Guess',
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
    );
  }
}
