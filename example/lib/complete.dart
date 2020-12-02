import 'package:flutter/material.dart';
import 'package:gpt_3_dart/gpt_3_dart.dart';

class CompletionForm extends StatefulWidget {
  final OpenAI openAI;
  CompletionForm(this.openAI);
  @override
  _CompletionFormState createState() => _CompletionFormState(openAI: openAI);
}

class _CompletionFormState extends State<CompletionForm> {
  OpenAI openAI;
  _CompletionFormState({@required this.openAI});
  final promptController = TextEditingController();
  final tokenController = TextEditingController();
  String generated = "";
  int tokens = 50;

  @override
  void dispose() {
    promptController.dispose();
    tokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: ListView(
      shrinkWrap: true,
      padding: EdgeInsets.all(15.0),
      children: [
        TextField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          controller: promptController,
          decoration: InputDecoration(
            hintText: "Enter prompt",
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: tokenController,
          decoration: InputDecoration(
            hintText: "Enter max tokens (default is 50)",
          ),
          onChanged: (String value) => {tokens = int.parse(value)},
        ),
        SizedBox(height: 15),
        MaterialButton(
          onPressed: () async {
            String complete =
                await openAI.complete(promptController.text, tokens);
            setState(() {
              generated = complete;
            });
          },
          child: Text('Generate'),
          color: Colors.blue,
          textColor: Colors.white,
        ),
        SizedBox(height: 15),
        Text(generated),
      ],
    )));
  }
}
