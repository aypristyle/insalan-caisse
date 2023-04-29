
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insalan_caisse/blocs/bottom_nav_bloc.dart';

class CreateAmicaliste extends StatelessWidget {

  final context;
  final state;
  final items;
  const CreateAmicaliste({super.key, required this.context, this.state, this.items});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    List<Widget> subButtons = [];
    for (var item in items) {
      subButtons.add(SizedBox(
          width: (MediaQuery
              .of(context)
              .size
              .width) / 3,
          child: RadioListTile(
            title: Text(item),
            value: item,
            groupValue: context.select((bloc) => state),
            onChanged: (index) => context
                .read<BottomNavBloc>().add(UpdateGroupValue(index.toString(), this.state))
          )));
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
            height: 45,
            child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: subButtons)),
      ],
    );
  }
}
