import 'package:flutter/widgets.dart';
import 'package:new_app/api/api_key.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:new_app/models/search_model.dart';

class SearchNews extends ChangeNotifier{
  List<SearchModel> results = [];
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _createUrl(Map<String, String> parameters) {
    return Uri(queryParameters: parameters).query;
  }

  Future getSearchNews(String query) async {
    _isLoading = true;
    results.clear();
    try {
      Map<String, String> parameters = {
        'q': query,
        'pageSize': '10',
        'apiKey': API_key,
      };

      final para = _createUrl(parameters);
      final String url = 'https://newsapi.org/v2/everything?$para';
      print(url);
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status'] == 'ok') {
          jsonData['articles'].forEach((element) {
            if (element['urlToImage'] != null &&
                element['description'] != null) {
              SearchModel searchModel = SearchModel(
                title: element['title'],
                description: element['description'],
                content: element['content'],
                image: element['urlToImage'],
                publish: element['publishedAt'],
                link: element['url'],
              );
              results.add(searchModel);
            }
          });
        }
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching news: $e');
      rethrow;
    } finally {
      _isLoading = false;
    }
  }
}
