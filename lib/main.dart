import 'package:flutter/material.dart';
import 'broken_location_filter_screen.dart';

void main() {
  runApp(const CandidateTestApp());
}

class CandidateTestApp extends StatelessWidget {
  const CandidateTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Candidate Location Test',
      theme: ThemeData(useMaterial3: true),
      home: const BrokenLocationFilterScreen(),
    );
  }
}
