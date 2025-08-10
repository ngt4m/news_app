import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:new_app/api/api_key.dart';
import 'package:new_app/models/category_model/show_category_model.dart';

class ShowCategoryData {
  List<ShowCategoryModel> categories = [];

  Future<void> GetShowCategoryData(String category) async {
    //gọi api cho category
    String url =
        'https://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=$API_key';

    var response = await http.get(Uri.parse(url));
    var jsonData = jsonDecode(response.body);

    if (jsonData['status'] == 'ok') {
      jsonData['articles'].forEach((element) {
        if (element['urlToImage'] != null && element['description'] != null) {
          ShowCategoryModel categoryModel = ShowCategoryModel(
        title: element['title'],
            description: element['description'],
            content: element['content'],
            image: element['urlToImage'],
            publish: element['publishedAt'],
            link: element['url'],
          );
          categories.add(categoryModel);
        }
      });
    }
  }
}
