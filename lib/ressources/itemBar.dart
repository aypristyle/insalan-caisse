
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insalan_caisse/blocs/bottom_nav_bloc.dart';

import '../blocs/bottom_nav_bloc.dart';

class ItemBar extends StatelessWidget {
  final context;
  final state;
  final scafoldkey;
  final bloc;
  const ItemBar({super.key, required this.context, required this.state, required this.scafoldkey, required this.bloc});
  List<String> getMenu(item){
    List<String> drinkItems = [];

    state.priceStock.forEach((key, value) {
      if (value[3] == item) {
        drinkItems.add(key);
      }
    });
    if (kDebugMode) {
      print(drinkItems);
    }
    return drinkItems;
  }


  List<Widget> create_get_item(List<String> items){
    List<Widget> subButtons=[];
    for(var item in items){

      subButtons.add(ListTile(
        leading: const Icon(Icons.local_cafe),
        title: Text(item),
        onTap: () {
          bloc.add(addOrIncrementValue(item));
          Navigator.pop(context);}
          ));
    };
    return subButtons;
  }
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(child: Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
              ),
              onPressed: () {

                scafoldkey.currentState!.showBottomSheet<void>((BuildContext context) {
                  return SizedBox(
                    height: 150,
                    child: ListView(
                        children: create_get_item(getMenu(0))
                    ),
                  );
                });
              },
              child: const Text('Snack'),
            )
        ),),
        Expanded(child: Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
              ),
              onPressed: () {

                scafoldkey.currentState!.showBottomSheet<void>((BuildContext context) {
                  return SizedBox(
                    height: 150,
                    child: ListView(
                        children: create_get_item(getMenu(1))
                    ),
                  );
                });
              },
              child: const Text('Boissons'),
            )
        ),),
        Expanded(child: Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
              ),
              onPressed: () {

                scafoldkey.currentState!.showBottomSheet<void>((BuildContext context) {
                  return SizedBox(
                    height: 150,
                    child: ListView(
                        children: create_get_item(getMenu(2))
                    ),
                  );
                });
              },
              child: const Text('Redbull'),
            )
        ),),

      ],
    );
  }
}
