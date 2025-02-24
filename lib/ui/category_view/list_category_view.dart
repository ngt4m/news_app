import 'package:flutter/material.dart';
import 'package:new_app/API_service/category_data/show_category_data.dart';
import 'package:new_app/models/category_model/show_category_model.dart';
import 'package:new_app/ui/category_view/show_category_view.dart';
class ListCategoryView extends StatefulWidget {
  final String name;
  const ListCategoryView({required this.name, Key? key}) : super(key: key);

  @override
  _ListCategoryViewState createState() => _ListCategoryViewState();
}

class _ListCategoryViewState extends State<ListCategoryView> {
  List<ShowCategoryModel> categories = [];
  bool _loading = true;

  @override
  void initState() {
    getCategory();
    super.initState();
  }

  Future<void> getCategory() async {
    ShowCategoryData newsCategory = ShowCategoryData();
    await newsCategory.GetShowCategoryData(widget.name.toLowerCase());
    setState(() {
      categories = newsCategory.categories;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(widget.name),
            ),
            body: Container(
              child: ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return ShowCategoryView(
                      image: categories[index].image!,
                      title: categories[index].title!,
                      publish: categories[index].publish!,
                      link: categories[index].link!,
                    );
                  }),
            ),
          );
  }
}
