import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'dart:html' as html;
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:insalan_caisse/blocs/bottom_nav_bloc.dart';
import 'package:insalan_caisse/ressources/CurrentCommandList.dart';

import 'package:insalan_caisse/ressources/ItemList.dart';import 'package:insalan_caisse/ressources/UpdateButton.dart';
import 'package:insalan_caisse/ressources/addItem.dart';
import 'package:insalan_caisse/ressources/createAmicaliste.dart';
import 'package:insalan_caisse/ressources/dropDownMenu.dart';
import 'package:insalan_caisse/ressources/itemBar.dart';
import 'package:insalan_caisse/ressources/pagecsv.dart';
import 'package:insalan_caisse/ressources/saveBar.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

import 'blocs/bottom_nav_state.dart';
import 'ressources/newStockButton.dart';
Future<void> main() async{
//  WidgetsFlutterBinding.ensureInitialized();
//  final storage = await HydratedStorage.build(
//    storageDirectory: kIsWeb
//        ? HydratedStorage.webStorageDirectory
 //       : await getTemporaryDirectory(),
 // );
  //HydratedBloc.storage = await HydratedStorage.build(storageDirectory: await getApplicationDocumentsDirectory());
  final BottomNavBloc myBloc = BottomNavBloc();
  runApp(MyApp(block: myBloc,));
 // HydratedBlocOverrides.runZoned(
 //       () => runApp(AppView()),
 //   storage: storage,
//  );
}
class MyPage extends StatefulWidget {
  final BottomNavBloc block;


  const MyPage({Key? key, required this.block}) : super(key: key);

  @override
  _MyPageState createState() {
    block.add(InitiateJson());
    return _MyPageState();

  }
}

class _MyPageState extends State<MyPage> {

  Widget _test (item,state,context, block){
    var deepEq = const DeepCollectionEquality();

    if (item == 0){
      return Column(
        children: [

          SizedBox(
            height: (MediaQuery.of(context).size.height/2.5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [


                ItemBar(context: context, state: state, scafoldkey:_scaffoldKey, bloc : block ),

                CreateAmicaliste(context: context,state: state.amicaliste, items:["Staff", "Visiteur", "Admin"]),
                CreateAmicaliste(context: context,state: state.payment, items:["CB", "Lyfpay", "Especes"]),
                SaveBar(context: context, state: state, bloc: block),
              ],
            ),
          ),
          SizedBox(height:MediaQuery. of(context). size. height/2,
            child: CurrentCommandList(context: context, state: state, bloc: block),
          ),
        ],
      );
    }
    else if(item ==1){
      return SizedBox(height:MediaQuery. of(context). size. height,
        child:Column(
          children: [
            SizedBox(
              height:MediaQuery. of(context). size. height/2 ,
              child: ItemList(state: state, context: context, bloc: block),),

            // dropdown button to select dictionary key
            Column(
              children: [
                SizedBox(
                    child: dropDownMenu(context: context, state: state, bloc:block)
                ),
                // text field to update the third value of the selected key
                SizedBox(width: MediaQuery. of(context). size. width/3,
                    child: newStockButton(context: context, state: state, bloc:block)
                ),
                // button to update third value

                SizedBox(width: MediaQuery. of(context). size. width/3,
                    child: UpdateButton(context: context, state: state, bloc:block)
                ),
              ],
            ),
            addItem(context: context, state: state, bloc:block)
          ],
        ),);
    }
    else{
      return pageCsv(context:context, state:state, bloc:block);
    }
}


  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      bottomNavigationBar:
      BlocBuilder<BottomNavBloc, BottomNavState>(
        builder: (BuildContext context, BottomNavState state) {
      return BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_sharp),
            label: 'Caisse',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
            label: 'Admin',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.ac_unit),
            label: 'Recap'
          ),

        ],
        currentIndex: context.select((block) => state.page), //New
        onTap: (index) => context
          .read<BottomNavBloc>().add(NavigateTo(index))
      );
        }),
      body:  BlocBuilder<BottomNavBloc, BottomNavState>(
          builder: (BuildContext context, BottomNavState state)
          {
            return _test( context.select((block) => state.page),state,context, widget.block);
          })

    );
  }
}
class MyApp extends StatelessWidget {
  final BottomNavBloc block;
  const MyApp({super.key, required this.block});
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home:BlocProvider(create: (context) => block,
      child :MyPage(block:block) ) ,
    );
  }
}
