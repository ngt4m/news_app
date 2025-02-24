import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:new_app/api/api_key.dart';
import 'package:new_app/models/article_model.dart';

class NewsData {
  List<ArticleModel> news = [];

  Future<void> GetNewsData() async {
    String url =
        'https://newsapi.org/v2/top-headlines?country=us&apiKey=$API_key';

    var response = await http.get(Uri.parse(url));
    var jsonData = jsonDecode(response.body);

    if (jsonData['status'] == 'ok') {
      jsonData['articles'].forEach((element) {
        if (element['urlToImage'] != null && element['description'] != null) {
          ArticleModel articleModel = ArticleModel(
          title: element['title'],
            description: element['description'],
            content: element['content'],
            image: element['urlToImage'],
            publish: element['publishedAt'],
            link: element['url'],
          );
          news.add(articleModel);
        };
      });
    }
  }
}
