library gpt3_dart;

import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';


class Param {
  String name;
  var value;

  Param(this.name, this.value);

  @override
  String toString() {
    return '{ ${this.name}, ${this.value} }';
  }
}

class OpenAI {
  String apiKey;
  OpenAI({@required this.apiKey});

  String getUrl(function, [engine]) {
    List engineList = ['ada', 'babbage', 'curie', 'davinci'];

    String url = 'https://api.openai.com/v1/engines/davinci/$function';

    if (engineList.contains(engine)) {
      url = 'https://api.openai.com/v1/engines/$engine/$function';
    }
    return url;
  }

  Future<String> complete(String prompt, int maxTokens,
      {num temperature,
      num topP,
      int n,
      bool stream,
      int logProbs,
      bool echo,
      String engine}) async {
    String apiKey = this.apiKey;

    List data = [];
    data.add(Param('temperature', temperature));
    data.add(Param('top_p', topP));
    data.add(Param('n', n));
    data.add(Param('stream', stream));
    data.add(Param('logprobs', logProbs));
    data.add(Param('echo', echo));
    Map map2 =
        Map.fromIterable(data, key: (e) => e.name, value: (e) => e.value);
    map2.removeWhere((key, value) => key == null || value == null);
    Map map1 = {"prompt": prompt, "max_tokens": maxTokens};
    Map reqData = {...map1, ...map2};
    var response = await http
        .post(
          getUrl("completions", engine),
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $apiKey",
            HttpHeaders.acceptHeader: "application/json",
            HttpHeaders.contentTypeHeader: "application/json",
          },
          body: jsonEncode(reqData),
        )
        .timeout(const Duration(seconds: 120));
    Map<String, dynamic> map = json.decode(response.body);
    List<dynamic> resp = map["choices"];

    return resp[0]["text"];
  }

  Future<List> search(List documents, String query, {engine}) async {
    Map reqData = {"documents": documents, "query": query};
    var response = await http
        .post(
          getUrl("search", engine),
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $apiKey",
            HttpHeaders.acceptHeader: "application/json",
            HttpHeaders.contentTypeHeader: "application/json",
          },
          body: jsonEncode(reqData),
        )
        .timeout(const Duration(seconds: 60));
    Map<String, dynamic> map = json.decode(response.body);
    List<dynamic> resp = map["data"];
    return resp;
  }
}
