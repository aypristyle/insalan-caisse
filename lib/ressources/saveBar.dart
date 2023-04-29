
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insalan_caisse/blocs/bottom_nav_bloc.dart';

import '../blocs/bottom_nav_bloc.dart';

class SaveBar extends StatelessWidget {

  final context;
  final state;
  final bloc;
  const SaveBar({super.key, required this.context, this.state, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Row( mainAxisSize: MainAxisSize.min,

        children: [

          Expanded(child: Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.deepPurpleAccent),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: const BorderSide(color: Colors.deepPurpleAccent)
                      )
                  )
              ),
                  onPressed: () => bloc.add(SaveCurrentCommande()), child: const Icon(Icons.check))
          ),),

          Expanded(child: Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.deepPurpleAccent),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: const BorderSide(color: Colors.deepPurpleAccent)
                        )
                    )
                ),
                onPressed: () => bloc.add(ClearCurrentCommande()),
                child: const Icon(Icons.clear_outlined),
              )
          ),),

          Expanded(child: Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed:  () => bloc.add(WriteFile()),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.deepPurpleAccent),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: const BorderSide(color: Colors.deepPurpleAccent)
                        )
                    )
                ),
                child: const Icon(Icons.save_alt),
              )
          ),),
        ]);
  }
}
