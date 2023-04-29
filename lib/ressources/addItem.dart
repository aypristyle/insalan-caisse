
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insalan_caisse/blocs/bottom_nav_bloc.dart';


class addItem extends StatelessWidget {
  final context;
  final state;
  final bloc;
  const addItem({super.key, required this.context, required this.state, required this.bloc});
  Future<List<double>?> _showValuesDialog(BuildContext context) async {
    List<double>? result = [0,0,0,0];
    Map<String,double> menu={
      "Bouffe":0,
      "Boissons":1,
      "Redbull":2
    };
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Enter values:"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: "Prix amicaliste"),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    if (value != "") {
                      result[0] = double.parse(value);
                    }
                  },
                ),
                TextField(
                  decoration: const InputDecoration(labelText: "Prix visiteur"),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    if (value != "") {
                      result![1] = double.parse(value);
                    }
                  },
                ),
                TextField(
                  decoration: const InputDecoration(labelText: "Stock"),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    if (value != "") {
                      result![2] = double.parse(value);
                    }
                  },
                ),
                DropdownButton<String>(
          value: "Boissons",
          hint: const Text("Select Categorie"),
          items: menu.keys.map((String key) {
          return DropdownMenuItem<String>(
          value: key,
          child: Text(key),
          );
          }).toList(),
          onChanged: (String? value) {
          if (value != "") {
          result![3] = menu[value]!;
          }
          },
          )
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop(result);
                },
              ),
            ],
          );
        });

    return result;
  }
  Future<String?> _showTextDialog(BuildContext context, String title) async {
    String? result = '';
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: TextField(
              onChanged: (value) {
                result = value;
              },
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop(result);
                },
              ),
            ],
          );
        });
    return result;
  }
  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(1),
        child:FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed:() async {
            final newKey = await _showTextDialog(context, "Enter key:");
            final newValues = await _showValuesDialog(context);
            if (newKey != null && newValues != null) {
              bloc.add(AddItemInStock(newKey,newValues));
            }
          },
        ));
  }
}
