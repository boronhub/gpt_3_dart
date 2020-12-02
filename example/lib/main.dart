import 'package:flutter/material.dart';
import 'complete.dart';
import 'search.dart';
import 'package:gpt_3_dart/gpt_3_dart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final OpenAI openAI =
      new OpenAI(apiKey: "YOUR_KEY_HERE");
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(text: "Completion"),
                Tab(text: "Search"),
              ],
            ),
            title: Text('GPT-3 API Demo'),
          ),
          body: TabBarView(
            children: [
              CompletionForm(openAI),
              SearchForm(openAI),
            ],
          ),
        ),
      ),
    );
  }
}
