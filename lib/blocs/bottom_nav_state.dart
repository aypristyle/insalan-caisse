
import 'dart:convert';

import 'package:flutter/services.dart';

class BottomNavState {
  final int page;
  final String amicaliste;
  final String payment;
  final String currentCommande;
  final List<String> commandeSummary;
  final Map<String, List<double>> priceStock;
  final String selectedKey;
// updated value from text field
  final double updatedValue;


  BottomNavState({
    required this.page,
    required this.payment,
    required this.amicaliste,
    required this.currentCommande,
    required this.commandeSummary,
    required this.priceStock,
    required this.selectedKey,
    required this.updatedValue
  });

  BottomNavState.initial()
      : page = 0,
        selectedKey = "kit kat",
        updatedValue=0,
        amicaliste = "Visiteur",
        payment = "CB",
        currentCommande = json.encode({}),
        commandeSummary = [],
        priceStock = {};
  Future<Map<String, List<double>>> retrievePrice() async {
    String jsonString = await rootBundle.loadString('assets/price.json');
    print(jsonString);
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    Map<String,List<double>> result = {};
    jsonMap.forEach((key, value) {
      List<double> doublesList = List.castFrom(value);
      result[key] = doublesList;
    });
    return result;
  }
  BottomNavState copyWith({
    int? page,
    String ? selectedKey,
    double ? updatedValue,
    String? amicaliste,
    String ? payment,
    String ? currentCommande,
    List<String>? commandeSummary,
    Map<String, List<double>>? priceStock,
  }) {
    return BottomNavState(
      selectedKey: selectedKey ?? this.selectedKey,
      updatedValue: updatedValue ?? this.updatedValue,
      page: page ?? this.page,
      amicaliste: amicaliste ?? this.amicaliste,
      currentCommande: currentCommande ?? this.currentCommande,
      commandeSummary: commandeSummary ?? this.commandeSummary,
      priceStock: priceStock ?? this.priceStock,
      payment: payment ?? this.payment
    );
  }

  @override
  String toString() {
    return 'MyState{page: $page, amicaliste: $amicaliste, currentCommande: $currentCommande, commandeSummary: $commandeSummary, priceStock: $priceStock}';
  }



  BottomNavState? fromJson(Map<String, dynamic> json) {
    return BottomNavState(page: json['page'] as int,
        payment: json['payment'] as String,
        amicaliste: json['amicaliste'] as String,
        currentCommande: json['currentCommande'] as String,
        commandeSummary: List<dynamic>.from(json["commandeSummary"].map((x) => x)) as List<String>,
        priceStock: json['priceStock'].decode() as Map<String, List<double>>,
        selectedKey: json['selectedKey'] as String,
        updatedValue: json['updatedValue'] as double);
  }

  Map<String, dynamic>? toJson() {
    return {
      'page':page,
      'amicaliste':amicaliste,
      'currentCommande':currentCommande,
      'commandeSummary':List<dynamic>.from(commandeSummary.map((x) => x)),
      'priceStock':priceStock,
      'selectedKey': selectedKey,
      'updatedValue': updatedValue,
      'payment': payment,
    };
  }
}

