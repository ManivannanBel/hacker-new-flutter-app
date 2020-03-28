import 'package:flutter/material.dart';
import 'screens/news_list.dart';
import 'bloc/stories_provider.dart';

class App extends StatelessWidget {
  Widget build(context) {
    return StoriesProvider(
      child: MaterialApp(
        title: 'News!',
        home: NewsList(),
      ),
    );
  }
}
