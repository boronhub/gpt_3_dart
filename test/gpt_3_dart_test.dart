import 'package:gpt_3_dart/gpt_3_dart.dart';

void main() async {
  OpenAI openAI = new OpenAI(apiKey: "YOUR_KEY_HERE");
  String complete = await openAI.complete("This is a test.", 10);
  List search = await openAI
      .search(["White House", "hospital", "school"], "the president");
  print(complete);
  print(search);
}
