import 'package:flutter/material.dart';

class DummyPage extends StatelessWidget {
  final String title;
  const DummyPage(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(title, style: TextStyle(fontSize: 24)));
  }
}
