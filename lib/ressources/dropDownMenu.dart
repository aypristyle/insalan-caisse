
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insalan_caisse/blocs/bottom_nav_bloc.dart';


class dropDownMenu extends StatelessWidget {
  final context;
  final state;
  final bloc;
  const dropDownMenu({super.key, required this.context, required this.state, required this.bloc});

  @override
  Widget build(BuildContext context) {
    Map<String, List<double>> priceStock = state.priceStock;
    return Padding(padding: EdgeInsets.symmetric(horizontal: 8.0),
        child:DropdownButton<String>(
          value: state.selectedKey,
          hint: const Text("Select an item"),
          items: priceStock.keys.map((String key) {
            return DropdownMenuItem<String>(
              value: key,
              child: Text(key),
            );
          }).toList(),
          onChanged: (String? newValue) {
            bloc.add(UpdateSelectKey(newValue!));
          },
        ));
  }
}
