import 'dart:async';

import 'package:connectivity/connectivity.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pharmer/crop_model.dart';
import 'package:pharmer/database_helper.dart';
import 'package:sqflite/sqflite.dart';

import 'crop_container.dart';
import 'crop_input.dart';

class CropList extends StatefulWidget {
  @override
  _CropListState createState() => new _CropListState();
}

class _CropListState extends State<CropList> {
  final databaseHelper = DatabaseHelper.instance;
  List<CropModel> crops = [];

  /*= [
    CropModel(
      name: 'Tomato',
      iconPath: 'images/tomato.png',
      subText: 'Requires 1 Amount of Water.',
      temp: 45,
      light: 10,
      water: 1,
    ),
    CropModel(
      name: 'Radish',
      iconPath: 'images/radish.png',
      subText: 'Requires 2 Amount of Water.',
      temp: 30,
      light: 8,
      water: 5,
    ),
    CropModel(
      name: 'Spinach',
      iconPath: 'images/spinach.png',
      subText: 'Requires 3 Amount of Water.',
      temp: 5,
      light: 10,
      water: 20,
    ),
    CropModel(
      name: 'Cucumber',
      iconPath: 'images/cucumber.png',
      subText: 'Requires 4 Amount of Water.',
      temp: 45,
      light: 9,
      water: 10,
    ),
    CropModel(
      name: 'Lettuce',
      iconPath: 'images/lettuce.png',
      subText: 'Requires 1 Amount of Water.',
      temp: 45,
      light: 10,
      water: 40,
    ),

  ];*/

  void _addNewCrop(String name, String sub, double soilMoisture,
      double airHumidity, double airTemp) async {
    String i = name.toLowerCase();
    final newCrop = CropModel(
      name: name,
      airHumidity: airHumidity,
      soilMoisture: soilMoisture,
      subText: sub,
      iconPath: 'images/$i.png',
      airTemp: airTemp,
    );
    await databaseHelper.insertCropToDB(newCrop);
    updateListView();
    final snackBar = SnackBar(content: Text('Added ' + name));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _deleteCrop(String name) async {
    final snackBar = SnackBar(content: Text('Deleted ' + name));
    await databaseHelper.deleteCropFromDB(name);
    updateListView();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _setCrop(int rack, String name, double soilMoisture, double airHumidity,
      double airTemp) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      DatabaseReference fdb = FirebaseDatabase.instance.reference();
      fdb.child("Reference/Rack: ${rack.toString()}/Name").set(name);
      fdb
          .child("Reference/Rack: ${rack.toString()}/soilMoisture")
          .set(soilMoisture);
      fdb
          .child("Reference/Rack: ${rack.toString()}/airHumidity")
          .set(airHumidity);
      fdb.child("Reference/Rack: ${rack.toString()}/airTemp").set(airTemp);
      fdb.child("Reference/Rack: ${rack.toString()}/isNew").set("newval");
      final snackBar = SnackBar(
          content: Text('Selected $name as Current Crop at rack: $rack'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final snackBar = SnackBar(content: Text('No Internet Connection!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    updateListView();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Select Crop"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => CropInputDialog(_addNewCrop),
            ),
          ),
        ],
      ),
      body: crops.isEmpty
          ? Center(
              child: Text(
                "No Crops Available\nAdd new crops",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              ),
            )
          : ListView.builder(
              itemCount: crops.length,
              itemBuilder: (BuildContext context, int index) {
                return cropContainer(
                    crops[index].iconPath,
                    crops[index].name,
                    crops[index].subText,
                    crops[index].soilMoisture,
                    crops[index].airHumidity,
                    crops[index].airTemp,
                    _deleteCrop,
                    _setCrop);
              },
            ),
    );
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initDatabase();
    dbFuture.then((database) {
      Future<List<CropModel>> cropListFuture = databaseHelper.crops();
      cropListFuture.then((crops) {
        setState(() {
          this.crops = crops;
        });
      });
    });
  }
}
