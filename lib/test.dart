import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
void main() {
  runApp(const MyApp());
}
class MyPage extends StatefulWidget {

  const MyPage({Key? key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  static bool  _menuBoisson = false;
  static Map<String, int> myCommande = {};
  // selected key from dropdown
  static String selectedKey = "kit kat";

// updated value from text field
  static double updatedValue = 0;
  static String _amicaliste="Visiteur";
  static String _paymentMethod = 'CB';
  static List<String> _commandeDay=[];

  Map<String, List<double>> prices_stock = {
    'kit kat': [10,20,12,0],
    'lion': [10,20,12,0],
    'ice tea': [10,20,12,1],
    'coca cola' : [10,20,12,1],
    'passion': [10,20,12,2],
    'mangue' : [10,20,12,2],
  };

  Future<void> writeToFile() async {
    String data = "";

    for (String line in _commandeDay) {
      data += "$line\n";
    }

    //   final String dir = (await getExternalStorageDirectory())!.path;
    //  if (kDebugMode) {
    //    print(dir);
    //  }
    //  final String path = '$dir/my_file.csv';
    //  final File file = File(path);

    // await file.writeAsString(data);
    //
    final blob = html.Blob([data], 'text/csv');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'my_file.csv')
      ..click();
    html.Url.revokeObjectUrl(url);
  }

// function to update the third value of the selected key
  void updateThirdValue() {
    // check if a key is selected and the updated value is not empty
    if (selectedKey.isNotEmpty && updatedValue != 0) {
      // get the list value of the selected key from the dictionary
      List<double>? valueList = prices_stock[selectedKey];

      // update the third value of the list
      valueList![2] = updatedValue;

      // print the updated dictionary
      if (kDebugMode) {
        print(prices_stock);
      }
    }
  }
  List<String> getMenu(item){
    List<String> drinkItems = [];

    prices_stock.forEach((key, value) {
      if (value[3] == item) {
        drinkItems.add(key);
      }
    });
    if (kDebugMode) {
      print(drinkItems);
    }
    return drinkItems;
  }
  void addOrIncrementValue(item) {
    if (item != ""){
      if (myCommande.containsKey(item)) {
        myCommande[item] = (myCommande[item])!+1;
      } else {
        myCommande[item] = 1;
      }

      if (kDebugMode) {
        print(myCommande);
      }
    }

  }

  List<Widget> create_payment() {
    List<Widget> subButtons = [];
    for (var item in ["CB", "Lyfpay", "Espèces"]) {
      subButtons.add(SizedBox(
          width:  (MediaQuery. of(context). size. width)/9,
          child:RadioListTile(
            title: Text(item),
            value: item,
            groupValue: _paymentMethod,
            onChanged: (value) {
              setState(() {
                _paymentMethod = value!;
              });
            },
          )));
    }
    return [SizedBox(
        height: 50,
        child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: subButtons))
    ];
  }

  List<Widget> createAmicaliste() {
    List<Widget> subButtons = [];
    for (var item in ["Staff", "Visiteur", "Admin"]) {
      subButtons.add(SizedBox(
          width: (MediaQuery. of(context). size. width)/9,
          child:RadioListTile(
            title: Text(item),
            value: item,
            groupValue: _amicaliste,
            onChanged: (value) {
              setState(() {
                _amicaliste = value!;
              });
            },
          )));
    }
    return [SizedBox(
        height: 50,
        child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: subButtons))
    ];
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

  Future<List<double>?> _showValuesDialog(BuildContext context) async {
    List<double>? result = [0,0,0,0];
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
                TextField(
                  decoration: const InputDecoration(labelText: "Categorie"),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    if (value != "") {
                      result![3] = double.parse(value);
                    }
                  },
                ),
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
  List<Widget> create_get_item(List<String> items){
    List<Widget> subButtons=[];
    for(var item in items){

      subButtons.add(ListTile(
        leading: const Icon(Icons.local_cafe),
        title: Text(item),
        onTap: () {
          addOrIncrementValue(item);

          Navigator.pop(context);
          setState(() {
            _menuBoisson = ! _menuBoisson;
          });
        },
      ),);
    }
    return subButtons;
  }



  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      //floatingActionButton:  FloatingActionButton(
      //  child: Icon(Icons.add),
      //  onPressed:() async {
      //    final newKey = await _showTextDialog(context, "Enter key:");
      //    final newValues = await _showValuesDialog(context);
      //    if (newKey != null && newValues != null) {
      //      setState(() {
      //        prices_stock[newKey] = newValues;
      //      });
      //     }
      //   },
      //  ),
      body:  Row(
        children: [
          SizedBox(width:MediaQuery. of(context). size. width/3,
            child:Expanded(

              child: ListView.builder(
                itemCount: myCommande.length,
                itemBuilder: (context, index) {
                  var key = myCommande.keys.elementAt(index);
                  var value = myCommande[key];
                  return ListTile(
                    title: Text(key),
                    subtitle: Text('Quantity: $value'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              myCommande[key] = value! + 1;
                            });
                          },
                          icon: const Icon(Icons.add),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              myCommande[key] = value! - 1;
                            });
                          },
                          icon: const Icon(Icons.remove),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),),
          SizedBox(
            width: (MediaQuery. of(context).size.width/3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [


                Row(mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
                          ),
                          onPressed: () {

                            _scaffoldKey.currentState!.showBottomSheet<void>((BuildContext context) {
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

                            _scaffoldKey.currentState!.showBottomSheet<void>((BuildContext context) {
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

                            _scaffoldKey.currentState!.showBottomSheet<void>((BuildContext context) {
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
                ),

                Row( mainAxisSize: MainAxisSize.min,
                  children: createAmicaliste(),),
                Row( mainAxisSize: MainAxisSize.min,
                  children: create_payment(),),
                Row( mainAxisSize: MainAxisSize.min,

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
                              onPressed: (){
                                List<double?> itemPrices=[0.0];

                                List<String> myCommandeList = [];

                                myCommande.forEach((item, count) {
                                  for (int i = 0; i < count; i++) {
                                    myCommandeList.add(item);
                                  }
                                });

                                myCommande.forEach((item, count) {
                                  prices_stock[item]![2]=prices_stock[item]![2]-count;
                                });

                                if (_amicaliste=='Staff'){

                                  itemPrices = myCommandeList.map((item) => prices_stock[item]![1]).toList();
                                }
                                if (_amicaliste=='Visiteur'){

                                  itemPrices = myCommandeList.map((item) => prices_stock[item]![0]).toList();

                                }
                                //List<int?> itemPrices = _commande.map((item) => prices[item]).toList();
                                double? sum = itemPrices.reduce((value, element) => value! + element!);
                                String sumsum =sum?.toStringAsFixed(2) ?? "0";
                                _commandeDay.add("$myCommande;$_amicaliste;$_paymentMethod;$sumsum");

                                myCommande={};
                              }, child: const Icon(Icons.check))
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
                            onPressed: () {
                              setState(() {
                                _commandeDay = [];
                              });
                            },
                            child: const Icon(Icons.clear_outlined),
                          )
                      ),),

                      Expanded(child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: ElevatedButton(
                            onPressed: writeToFile,
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
                    ]),
              ],
            ),
          ),
          SizedBox(width:MediaQuery. of(context). size. width/3,
            child:Column(
              children: [
                SizedBox(
                  height:MediaQuery. of(context). size. height/2 ,
                  child:Expanded(
                    child: ListView.builder(
                      itemCount: prices_stock.length,
                      itemBuilder: (context, index) {
                        String key = prices_stock.keys.elementAt(index);
                        List<double> values = prices_stock.values.elementAt(index);
                        return ListTile(
                          title: Text(key),
                          subtitle: Text("Values: $values"),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                prices_stock.remove(key);
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),),

                // dropdown button to select dictionary key
                Row(
                  children: [
                    SizedBox(width: MediaQuery. of(context). size. width/9,
                        child: Padding(padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child:DropdownButton<String>(
                              value: selectedKey,
                              hint: const Text("Select an item"),
                              items: prices_stock.keys.map((String key) {
                                return DropdownMenuItem<String>(
                                  value: key,
                                  child: Text(key),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedKey = newValue!;
                                });
                              },
                            ))
                    ),
                    // text field to update the third value of the selected key
                    SizedBox(width: MediaQuery. of(context). size. width/9,
                        child: Padding(padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child:TextField(
                              decoration: const InputDecoration(
                                labelText: "New stock",
                              ),
                              onChanged: (String value) {
                                setState(() {
                                  updatedValue = double.tryParse(value)!;
                                });
                              },
                            ))
                    ),
                    // button to update third value

                    SizedBox(width: MediaQuery. of(context). size. width/9,
                        child: Padding(padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child:ElevatedButton(
                              onPressed: updateThirdValue,
                              child: const Text("Update"),
                            ))
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.all(20),
                    child:FloatingActionButton(
                      child: const Icon(Icons.add),
                      onPressed:() async {
                        final newKey = await _showTextDialog(context, "Enter key:");
                        final newValues = await _showValuesDialog(context);
                        if (newKey != null && newValues != null) {
                          setState(() {
                            prices_stock[newKey] = newValues;
                          });
                        }
                      },
                    ))
              ],
            ),),
        ],
      ),

    );
  }
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyPage(),
    );
  }
}
