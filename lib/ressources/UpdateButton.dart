
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insalan_caisse/blocs/bottom_nav_bloc.dart';


class UpdateButton extends StatelessWidget {
  final context;
  final state;
  final bloc;
  const UpdateButton({super.key, required this.context, required this.state, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.symmetric(horizontal: 8.0),
        child:ElevatedButton(
          onPressed: () => bloc.add(UpdatedThirdValue()),
          child: const Text("Update"),
        ));
  }
}
