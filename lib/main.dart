import 'package:flutter/material.dart';
import 'package:new_app/API_service/search_news.dart';
import 'package:new_app/home_screen/home_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    Provider(
      create: (_) => SearchNews(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
