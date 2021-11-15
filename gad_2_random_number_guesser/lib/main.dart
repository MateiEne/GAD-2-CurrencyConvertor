import 'dart:math';

import 'package:flutter/material.dart';

import 'package:gad_2_random_number_guesser/pages/home.dart';
import 'package:gad_2_random_number_guesser/pages/leader_board.dart';

void main() {
  runApp(const RandomNumberGuesser());
}

class RandomNumberGuesser extends StatelessWidget {
  const RandomNumberGuesser({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) {
          return const HomePage();
        },
        '/leaderboard': (context) {
          return const LeaderBoardPage();
        }
      },
    );
  }
}

