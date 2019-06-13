import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsApi {
  final String url = 'http://104.131.18.84';

  Future<Map> loadNews(String page) async {
    String apiUrl = '$url/notice/news/geral/$page';
    try {
      http.Response response = await http.get(apiUrl);
      const JsonDecoder decoder = const JsonDecoder();
      return decoder.convert(response.body);
    } on Exception catch (_) {
      return null;
    }
  }

  Future<Map> loadNewsRecent() async {
    String apiUrl = '$url/notice/news/recent';

    try {
      http.Response response = await http.get(apiUrl);
      const JsonDecoder decoder = const JsonDecoder();
      return decoder.convert(response.body);
    } on Exception catch (_) {
      return null;
    }
  }

  // TODO Bonus
  Future<Map> loadSearch(query) async {
    String apiUrl = '$url/notice/search/$query';
    try {
      http.Response response = await http.get(apiUrl);
      // Using the JSON class to decode the JSON String
      const JsonDecoder decoder = const JsonDecoder();
      return decoder.convert(response.body);
    } on Exception catch (_) {
      return null;
    }
  }
}
