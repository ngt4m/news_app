import 'package:flutter/material.dart';
import 'package:new_app/API_service/search_news.dart';
import 'package:new_app/ui/home_screen/article_view.dart';
import 'package:new_app/models/search_model.dart';
import 'package:provider/provider.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 239, 245, 245),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Search'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(10),
            child: TextBox(),
          ),
          Expanded(
            child: Consumer<SearchNews>(
              builder: (context, search, child) {
                if (search.isLoading && search.results.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                } else if (search.results.isEmpty) {
                  return const Center(child: Text('No results found'));
                }
                return ListView.builder(
                  controller: scrollController,
                  itemCount: search.results.length,
                  itemBuilder: (context, index) {
                    final SearchModel searchNews = search.results[index];
                    return listItems(searchNews, context);
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

Widget listItems(SearchModel search, BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ArticleView(linkArticle: search.link),
        ),
      );
    },
    child: Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        leading: Image.network(
          search.image,
          height: 60,
          width: 100,
          fit: BoxFit.cover,
        ),
        title: Text(
          search.title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(search.publish),
      ),
    ),
  );
}

class TextBox extends StatefulWidget {
  const TextBox({Key? key}) : super(key: key);

  @override
  _TextBoxState createState() => _TextBoxState();
}

class _TextBoxState extends State<TextBox> {
  final focus = FocusNode();
  final TextEditingController textSearch = TextEditingController();
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
  void dispose() {
    focus.dispose();
    textSearch.dispose();
    super.dispose();
  }

  void _searchNews() {
    final text = textSearch.text.trim();
    if (text.isNotEmpty) {
      FocusScope.of(context).unfocus();
      final searchProvider = Provider.of<SearchNews>(context, listen: false);
      searchProvider.getSearchNews(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focus,
      controller: textSearch,
      decoration: InputDecoration(
        hintText: 'Search',
        suffixIcon: IconButton(
          onPressed: _searchNews,
          icon: const Icon(Icons.search),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onSubmitted: (value) {
        if (value.trim().isNotEmpty) {
          _searchNews();
        }
      },
    );
  }
}
