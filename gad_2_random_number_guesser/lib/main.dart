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
              padding: EdgeInsets.fromLTRB(16, 16, 16, 32),
              child: Text(
                "It's your turn to guess my number!",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Card(
              elevation: 24.0,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.88,
                height: MediaQuery.of(context).size.height * 0.28,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Expanded(
                        flex: 3,
                        child: Text(
                          'Try a number!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 32.0,
                          ),
                        ),
                      ),
                      const Expanded(
                        flex: 2,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Enter a number',
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Guess'),
                      )
                    ],
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
