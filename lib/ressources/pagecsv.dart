
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insalan_caisse/blocs/bottom_nav_bloc.dart';
import 'package:csv/csv.dart';


class pageCsv extends StatelessWidget {
  final context;
  final state;
  final bloc;
  const pageCsv({super.key, required this.context, required this.state, required this.bloc});
  List<DataRow> get_rows(List<String> csvRows) {
    List<List<dynamic>> csvTable = [];
    List<DataRow> rows = [];
    csvRows.forEach((row) {
      List<dynamic> rowValues = row.split(';');
      csvTable.add(rowValues);
    });

    for (int i = 0; i < csvTable.length; i++) {
      List<DataCell> cells = [];
      for (int j = 0; j < csvTable[i].length; j++) {
        cells.add(DataCell(Text(csvTable[i][j].toString())));
      }
      rows.add(DataRow(cells: cells));
    }
      return rows;
  }
  @override
  Widget build(BuildContext context) {
    var test=["amicaliste;payment","amicaliste;CB"];
    List<List<dynamic>> csvTable = [];
    test.forEach((row) {
      csvTable.add(CsvToListConverter().convert(row)[0]);
    });

    String csvString = const ListToCsvConverter().convert(csvTable);

    return SingleChildScrollView(
      child:  DataTable(
    columns: const <DataColumn>[
    DataColumn(
    label: Expanded(
    child: Text(
    'Commande',
      style: TextStyle(fontStyle: FontStyle.italic),
    ),
    ),
    ),
    DataColumn(
    label: Expanded(
    child: Text(
    'Amicaliste ?',
    style: TextStyle(fontStyle: FontStyle.italic),
    ),
    ),
    ),
    DataColumn(
    label: Expanded(
    child: Text(
    'Payment',
    style: TextStyle(fontStyle: FontStyle.italic),
    ),
    ),
    ),
      DataColumn(
        label: Expanded(
          child: Text(
            'Total',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ),
    ],
    rows: get_rows(context.select((bloc) => state.commandeSummary)),
    ),

    );
  }
}
