import 'dart:async';
import 'package:flutter/material.dart';
import '../models/item_model.dart';
import './loading_container.dart';

class Comment extends StatelessWidget {
  final int itemId;
  final Map<int, Future<ItemModel>> itemMap;
  final depth;

  Comment({this.itemId, this.itemMap, this.depth});

  Widget build(contex) {
    return FutureBuilder(
        future: itemMap[itemId],
        builder: (context, AsyncSnapshot<ItemModel> snapshot) {
          if (!snapshot.hasData) {
            return LoadingContainer();
          }

          final children = <Widget>[
            ListTile(
              title: BuildText(snapshot.data.text),
              subtitle: snapshot.data.by == ""
                  ? Text('Deleted')
                  : Text(snapshot.data.by),
              contentPadding: EdgeInsets.only(
                right: 16.0,
                left: depth * 16.0,
              ),
            ),
            Divider(),
          ];
          snapshot.data.kids.forEach((kidId) {
            children.add(
              Comment(
                itemId: kidId,
                itemMap: itemMap,
                depth: depth + 1,
              ),
            );
          });

          return Column(
            children: children,
          );
        });
  }

  Widget BuildText(text) {
    final newText = text
        .replaceAll('&#x27;', "'")
        .replaceAll('<p>', "\n\n")
        .replaceAll('</p>', '');

    return Text(newText);
  }
}
