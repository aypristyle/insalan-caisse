
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insalan_caisse/blocs/bottom_nav_bloc.dart';


class ItemList extends StatelessWidget {
  final context;
  final state;
  final bloc;
  const ItemList({super.key, required this.context, required this.state, required this.bloc});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: state.priceStock.length,
        itemBuilder: (context, index) {
          String key = state.priceStock.keys.elementAt(index);
          List<double> values = state.priceStock.values.elementAt(index);
          return ListTile(
            title: Text(key),
            subtitle: Text("Values: $values"),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                bloc.add(DeleteItemFromItemList(key));
              },
            ),
          );
        },
      ),
    );
  }
}
