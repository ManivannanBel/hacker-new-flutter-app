import 'dart:async';
import 'package:flutter/material.dart';
import 'package:new_app/src/bloc/comments_provider.dart';
import '../models/item_model.dart';
import '../widgets/comment.dart';

class NewsDetail extends StatelessWidget {
  final int itemId;

  NewsDetail({this.itemId});

  Widget build(context) {
    final commentsBloc = CommentsProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
      ),
      body: BuildBody(commentsBloc),
    );
  }

  Widget BuildBody(CommentsBloc bloc) {
    return StreamBuilder(
      stream: bloc.itemWithComments,
      builder: (context, AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot) {
        if (!snapshot.hasData) {
          return Text('loading');
        }

        final itemFuture = snapshot.data[itemId];

        return FutureBuilder(
          future: itemFuture,
          builder: (context, AsyncSnapshot<ItemModel> itemSnapshot) {
            if (!itemSnapshot.hasData) {
              return Text('loading');
            }

            return BuildList(itemSnapshot.data, snapshot.data);
          },
        );
      },
    );
  }

  Widget BuildList(ItemModel item, Map<int, Future<ItemModel>> itemMap) {
    final children = <Widget>[];
    children.add(BuildTitle(item));

    final commentList = item.kids.map((kidId) {
      return Comment(
        itemId: kidId,
        itemMap: itemMap,
        depth: 1,
      );
    }).toList();

    children.addAll(commentList);

    return ListView(
      children: children,
    );
  }

  Widget BuildTitle(ItemModel item) {
    return Container(
      margin: EdgeInsets.all(10.0),
      alignment: Alignment.topCenter,
      child: Text(
        item.title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
