
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insalan_caisse/blocs/bottom_nav_bloc.dart';


class CurrentCommandList extends StatelessWidget {
  final context;
  final state;
  final bloc;
  const CurrentCommandList({super.key, required this.context, required this.state, required this.bloc});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: json.decode(bloc.state.currentCommande).length,
      itemBuilder: (context, index) {
        var key = json.decode(bloc.state.currentCommande).keys.elementAt(index);
        var value = json.decode(bloc.state.currentCommande)[key];
        return ListTile(
          title: Text(key),
          subtitle: Text('Quantity: $value'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  bloc.add(IncreaseItem(key));
                },
                icon: const Icon(Icons.add),
              ),
              IconButton(
                onPressed: () {
                  bloc.add(DecreaseItem(key));
                },
                icon: const Icon(Icons.remove),
              ),
            ],
          ),
        );
      },
    );
  }
}
