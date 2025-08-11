import 'package:flutter/material.dart';
import 'package:new_app/API_service/search_news.dart';
import 'package:new_app/ui/home_screen/article_view.dart';
import 'package:new_app/models/search_model.dart';
import 'package:provider/provider.dart';
import 'dart:async';

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
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    focus.addListener(() => setState(() => isFocus = focus.hasFocus));
    textSearch.addListener(() => setState(() {})); // to show/hide clear button
  }

  @override
  void dispose() {
    _debounce?.cancel();
    focus.dispose();
    textSearch.dispose();
    super.dispose();
  }

  void _runSearch(String query) {
    final q = query.trim();
    if (q.isEmpty) return;
    FocusScope.of(context).unfocus();
    Provider.of<SearchNews>(context, listen: false).getSearchNews(q);
  }

  void _searchNow() => _runSearch(textSearch.text);

  // optional debounce when typing
  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 450), () {
      if (value.trim().isNotEmpty) _runSearch(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasText = textSearch.text.isNotEmpty;

    return TextField(
      focusNode: focus,
      controller: textSearch,
      textInputAction: TextInputAction.search,
      onSubmitted: (_) => _searchNow(),
      onChanged: _onChanged,
      decoration: InputDecoration(
        hintText: 'Search',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasText)
              IconButton(
                tooltip: 'Clear',
                icon: const Icon(Icons.close),
                onPressed: () {
                  textSearch.clear();
                },
              ),
          ],
        ),
        filled: true,
        fillColor: Theme.of(context).inputDecorationTheme.fillColor ??
            Colors.grey.withOpacity(0.08),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary, width: 1.6),
        ),
      ),
    );
  }
}
