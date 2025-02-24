import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:new_app/api/api_key.dart';
import 'package:new_app/models/slider_model.dart';
import 'package:intl/intl.dart';
class SliderData {
  List<SliderModel> sliders = [];

  Future<void> GetSliderData() async {
DateTime now = DateTime.now();
DateTime formatDate = now.subtract(Duration(days: 2));

    String url = 'https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=$API_key';

    var response = await http.get(Uri.parse(url));
    var jsonData = jsonDecode(response.body);

    if (jsonData['status'] == 'ok') {
      jsonData['articles'].forEach((element) {
        if (element['urlToImage'] != null && element['description'] != null) {
          SliderModel sliderModel = SliderModel(
            title: element['title'],
            description: element['description'],
            content: element['content'],
            image: element['urlToImage'],
            publish: element['publishedAt'],
            link: element['url'],
          );
          sliders.add(sliderModel);
        }
      });
    }
  }
}
