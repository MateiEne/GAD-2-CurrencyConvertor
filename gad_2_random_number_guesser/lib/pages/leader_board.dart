import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeaderBoardPage extends StatefulWidget {
  const LeaderBoardPage({Key? key}) : super(key: key);

  @override
  _LeaderBoardPageState createState() => _LeaderBoardPageState();
}

class _LeaderBoardPageState extends State<LeaderBoardPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<List<String>> _leaderboard;

  @override
  void initState() {
    super.initState();
    _leaderboard = _prefs.then((SharedPreferences prefs) {
      return (prefs.getStringList('leaderboard') ?? []);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<String>>(
        future: _leaderboard,
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const CircularProgressIndicator();

            default:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              snapshot.data!. sort((String s1, String s2) {
                List<String> split1 = s1.split(" ");
                List<String> split2 = s2.split(" ");

                return split1[1].compareTo(split2[1]);
              });

              return ListView(children: [
                Column(
                  children: snapshot.data!.take(10).map((String value) {
                    List<String> splits = value.split(" ");

                    return Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Row(
                        children: [
                          Text(
                            splits[0],
                            style: const TextStyle(
                              fontSize: 32,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            splits[1],
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 32,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ]);
          }
        },
      ),
    );
  }
}
