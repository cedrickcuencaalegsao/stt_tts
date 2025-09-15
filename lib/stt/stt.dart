import 'package:flutter/material.dart';

class STTPage extends StatefulWidget {
  const STTPage({super.key});

  @override
  State<STTPage> createState() => STTPageState();
}

class STTPageState extends State<STTPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Speech to text.")));
  }
}
