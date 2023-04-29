
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insalan_caisse/blocs/bottom_nav_bloc.dart';


class newStockButton extends StatelessWidget {
  final context;
  final state;
  final bloc;
  const newStockButton({super.key, required this.context, required this.state, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.symmetric(horizontal: 8.0),
        child:TextField(
          decoration: const InputDecoration(
            labelText: "New stock",
          ),
          onChanged: (String value) {
            bloc.add(UpdateNewStockValue(double.tryParse(value)!));
          },
        ));
  }
}
