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
      body: Center(
        child: FutureBuilder<List<String>>(
          future: _leaderboard,
          builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const CircularProgressIndicator();

              default:
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                return Column(
                  children: snapshot.data!.map((String value) {
                    List<String> splits = value.split(" ");

                    return Row(
                      children: [
                        Text(splits[0]),
                        const Spacer(),
                        Text(splits[1]),
                      ],
                    );
                  }).toList(),
                );
            }
          },
        ),
      ),
    );
  }
}
