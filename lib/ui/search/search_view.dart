import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:new_app/API_service/search_news.dart';
import 'package:new_app/home_screen/article_view.dart';
import 'package:new_app/models/search_model.dart';
import 'package:provider/provider.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  _SearchViewState createState() => _SearchViewState();
}

//search video
class _SearchViewState extends State<SearchView> {
  final ScrollController scrollController = ScrollController();



  void _SearchNews() {
    final search = Provider.of<SearchNews>(context, listen: false);
    search.GetSearchNews(TextBox.textsearch.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 239, 245, 245),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Search'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(10),
            child: TextBox(),
          ),
          Expanded(
            child: Consumer<SearchNews>(
              builder: (context, search,child){
                if(search.isLoading && search.results.isEmpty){
                  return const Center(child: CircularProgressIndicator(),);
                }
             
                return ListView.builder(
                  controller: scrollController,
                  itemCount: search.results.length,
                  itemBuilder: (context, index) {
                    final SearchModel searchNews  = search.results[index];
                    return ListItems(searchNews, context);
                  }
                );

              },
            ),
          )
        ],
      ),
    );
  }
}

Widget ListItems(SearchModel search, BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ArticleView(linkArticle: search.link),
        ),
      );
    },
    child: ListTile(
      leading: Image.network(
        search.image,
        height: 60,
        width: 100,
        fit: BoxFit.cover,
      ),
      title: Text(
        search.title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w300,
        ),
      ),
      subtitle: Text(search.publish),
    ),
  );
}

class TextBox extends StatefulWidget {
  const TextBox({Key? key}) : super(key: key);
  static TextEditingController textsearch = TextEditingController();
  @override
  _TextBoxState createState() => _TextBoxState();
}

class _TextBoxState extends State<TextBox> {
  final focus = FocusNode();
  bool isFocus = false;
  @override
  void initState() {
    super.initState();
    focus.addListener(() {
      setState(() {
        isFocus = focus.hasFocus;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
     
          decoration: InputDecoration(
            hintText: 'Search',
            suffixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          controller: TextBox.textsearch,
          onSubmitted: (value) {
            final newsProvider =
                Provider.of<SearchNews>(context, listen: false);
            newsProvider.GetSearchNews(value);
          },
        ),
      ],
    );
  }
}
