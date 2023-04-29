import 'dart:convert';
import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'dart:async';
import 'package:equatable/equatable.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';


import 'package:path_provider/path_provider.dart';

import 'bottom_nav_state.dart';

part 'bottom_nav_event.dart';

class BottomNavBloc extends Bloc<BottomNavEvent, BottomNavState> {
  BottomNavBloc() : super(BottomNavState.initial());

  @override
  Stream<BottomNavState> mapEventToState(BottomNavEvent event) async* {
    // this is where the events are handled, if you want to call a method
    // you can yield* instead of the yield, but make sure your
    // method signature returns Stream<NavDrawerState> and is async*
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    String jsonStringPriceStock ="";
    String jsonStringCurrentCommand="";
    String jsonStringCommandDay="";
    List<String> commandday=[];
    // Create a File object for the JSON file
    File jsonpricestock = File('$appDocPath/pricestock.json');
    File jsoncurrentcommand = File('$appDocPath/currentcommand.json');
    File jsoncommandday = File('$appDocPath/commandday.csv');
    if (event is InitiateJson){
      print(jsonpricestock.readAsString());
      if (await jsonpricestock.exists()) {
        // Read the JSON data from the file
         jsonStringPriceStock = await jsonpricestock.readAsString();
      } else {
        // Write the JSON data to the file
        jsonStringPriceStock = '{"kit kat":[10,25,2,0]}';
      }
      if (await jsoncurrentcommand.exists()) {
        // Read the JSON data from the file
        jsonStringCurrentCommand = await jsoncurrentcommand.readAsString();
      } else {
        // Write the JSON data to the file
        jsonStringCurrentCommand = '{}';
      }
      if (await jsoncommandday.exists()) {
        // Read the JSON data from the file
        jsonStringCurrentCommand = await jsoncommandday.readAsString();
        commandday=jsonStringCurrentCommand.split('\n');
      }

      final Map<String, dynamic> jsonMap = json.decode(jsonStringPriceStock);
      Map<String,List<double>> result = {};
      jsonMap.forEach((key, value) {
        List<dynamic> dynamicList = List.castFrom(value);
        List<double>? doublesList = dynamicList.map((e) => e.toDouble()).cast<double>().toList();
        result[key] = doublesList;
      });

                yield state.copyWith(
              priceStock: result,
                  currentCommande: jsonStringCurrentCommand,
                  commandeSummary: commandday
          );


    }
    if(event is UpdateCommand){
      yield state.copyWith(currentCommande: event.myCommande);
    }
    if (event is NavigateTo) {
      // only route to a new location if the new location is different
      if (event.page != state.page) {
        yield state.copyWith(
            page: event.page
        );
      }
    }
    if (event is AddItemInStock){
      var val=state.priceStock;
      val[event.key]=event.item;
      jsonpricestock.writeAsStringSync(json.encode(val));
      yield state.copyWith(
        priceStock: val,
          selectedKey: event.key
      );
    }
    if (event is UpdatedThirdValue){
        // check if a key is selected and the updated value is not empty
        if (state.selectedKey.isNotEmpty && state.updatedValue != 0) {
          // get the list value of the selected key from the dictionary
          var val = state.priceStock;
          val[state.selectedKey]![2]=state.updatedValue;
          jsonpricestock.writeAsStringSync(json.encode(val));
          // update the third value of the list
          // print the updated dictionary
          yield state.copyWith(
              priceStock : val
          );
        }

    }
    if (event is UpdateSelectKey){
      if (event.item != ""){
        yield state.copyWith(
          selectedKey: event.item
        );

      }
    }
    if (event is UpdateNewStockValue){
      if (event.item != 0.0){
        yield state.copyWith(
            updatedValue: event.item
        );

      }
    }
    if (event is UpdateGroupValue){

      if (event.kind == state.amicaliste) {
        if(event.value != state.amicaliste){
          yield state.copyWith(
              amicaliste: event.value,
          );
        }
      }
      if (event.kind == state.payment) {
        if(event.value != state.payment){
          var c=json.decode(state.currentCommande);
          c[event.value]=1;
          yield state.copyWith(
              payment: event.value,
          );
        }
      }
    }
    if (event is DeleteItemFromItemList){
      var s =state.priceStock;
      s.remove(event.item);
      jsonpricestock.writeAsStringSync(json.encode(s));
      yield state.copyWith(
        priceStock: s,
      );
    }
    if (event is SaveCurrentCommande){
      List<double?>? itemPrices=[0.0];

      List<String> myCommandeList = [];

      json.decode(state.currentCommande).forEach((item, count) {
        for (int i = 0; i < count; i++) {
          myCommandeList.add(item);
        }
      });

      json.decode(state.currentCommande).forEach((item, count) {
        state.priceStock[item]![2]=(state.priceStock[item]![2]-count).toDouble();
      });

      if (state.amicaliste=='Staff'){

        itemPrices = myCommandeList.map((item) => state.priceStock[item]![1]).cast<double?>().toList();
      }
      if (state.amicaliste=='Visiteur'){

        itemPrices = myCommandeList.map((item) => state.priceStock[item]![0]).cast<double?>().toList();

      }

      //List<int?> itemPrices = _commande.map((item) => prices[item]).toList();
      double? sum = itemPrices.reduce((value, element) => value! + element!);
      String sumsum =sum?.toStringAsFixed(2) ?? "0";
      var currentcommand=state.commandeSummary;
      currentcommand.add(state.currentCommande.toString()+";"+state.amicaliste+";"+ state.payment+";$sumsum");
      print(currentcommand);
      String data="";
      for (String line in state.commandeSummary) {
        data += "$line\n";
      }
      await jsoncommandday.writeAsString(data);
      yield state.copyWith(
          commandeSummary: currentcommand,
          currentCommande: "{}"
      );
    }

    if (event is addOrIncrementValue){

      if (event.item != ""){
        var current =  json.decode(state.currentCommande);
        if (current.containsKey(event.item)) {
          current[event.item]= (current[event.item])+1;
        } else {
          current[event.item] = 1;
        }
        jsoncurrentcommand.writeAsStringSync(json.encode(current));
        print(current);
        yield state.copyWith(
            currentCommande: json.encode(current)
        );
      }
    }

    if (event is IncreaseItem){

      if (event.item != ""){
        var current =  json.decode(state.currentCommande);
        if (current.containsKey(event.item)) {
          current[event.item]= (current[event.item])+1;
        }
        jsoncurrentcommand.writeAsStringSync(json.encode(current));
        yield state.copyWith(
            currentCommande: json.encode(current)
        );
      }
    }
    if (event is DecreaseItem){

      if (event.item != ""){
        var current =  json.decode(state.currentCommande);
        if (current.containsKey(event.item)) {
          current[event.item]= (current[event.item])-1;
        }
        if (current[event.item]==0){
          current.remove(event.item);
        }
        jsoncurrentcommand.writeAsStringSync(json.encode(current));
        yield state.copyWith(
            currentCommande: json.encode(current)
        );
      }
    }
    if (event is ClearCurrentCommande){
      jsoncurrentcommand.writeAsStringSync(json.encode('{}'));
      yield state.copyWith(
          currentCommande: "{}"
      );
    }
    if (event is WriteFile){
      yield* _writeToFile();
    }


  }
  Stream<BottomNavState> _writeToFile() async* {
    String data = "";

    for (String line in state.commandeSummary) {
      data += "$line\n";
    }

    final String dir = (await getExternalStorageDirectory())!.path;
    if (kDebugMode) {
      print(dir);
    }
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    final String path = '$dir/save$timestamp.csv';
    final File file = File(path);

    await file.writeAsString(data);
    yield state.copyWith(
        currentCommande: json.encode({}),
        commandeSummary: []
    );
  }

  @override
  BottomNavState? fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    try {
      return state.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(BottomNavState state) {
    // TODO: implement toJson
    try {
      return state.toJson();
    } catch (_) {
      return null;
    }
  }
}
