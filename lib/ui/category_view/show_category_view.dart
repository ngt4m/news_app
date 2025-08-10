import 'package:flutter/material.dart';
import 'package:new_app/ui/home_screen/article_view.dart';

class ShowCategoryView extends StatelessWidget {
  final String title, image, publish, link;
  const ShowCategoryView({
    required this.image,
    required this.title,
    required this.publish,
    required this.link,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ArticleView(linkArticle: link)));
      },
      child: Padding(
        padding: EdgeInsets.all(3),
        child: Card(
          child: ListTile(
            leading: Image.network(
              image,
              height: 60,
              width: 100,
              fit: BoxFit.cover,
            ),
            title: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(publish),
          ),
        ),
      ),
    );
  }
}
