import 'package:connectivity/connectivity.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CurrentPage extends StatefulWidget {
  @override
  _CurrentPageState createState() => _CurrentPageState();
}

class _CurrentPageState extends State<CurrentPage> {
  var racks = ['', ''];
  var deleteStatus = ['', ''];
  var numRack = 2;

  @override
  initState() {
    super.initState();
    _checkCrop();
  }

  void _checkCrop() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      DatabaseReference fdb = FirebaseDatabase.instance.reference();
      for (int i = 0; i < numRack; i++) {
        await fdb
            .child("Reference/Rack: ${i + 1}/isNew")
            .once()
            .then((DataSnapshot data) {
          setState(() {
            deleteStatus[i] = data.value;
          });
        });
      }
      print("DeleteStatus $deleteStatus");
      for (int i = 0; i < numRack; i++) {
        if (deleteStatus[i] == "deleted") {
          setState(() {
            racks[i] = '';
          });
        } else {
          await fdb
              .child("Reference/Rack: ${i + 1}/Name")
              .once()
              .then((DataSnapshot data) {
            setState(() {
              racks[i] = data.value;
            });
          });
        }
      }
      final snackBar = SnackBar(content: Text('Refreshed!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final snackBar = SnackBar(content: Text('No Internet Connection!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void _deleteSetCrop(String rack) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      DatabaseReference fdb = FirebaseDatabase.instance.reference();
      fdb.child("Reference/Rack: $rack/isNew").set("deleted");
      setState(() {
        racks[int.parse(rack) - 1] = '';
        deleteStatus[int.parse(rack) - 1] = "deleted";
      });
      // _checkCrop();
      final snackBar = SnackBar(content: Text('Deleted crop at Rack: $rack'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final snackBar = SnackBar(content: Text('No Internet Connection!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  String textSetValue(int index) {
    if (racks[index] == '')
      return 'No Crop';
    else
      return racks[index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          "Currently Planted Crops",
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _checkCrop,
        backgroundColor: Colors.green,
        child: const Icon(Icons.refresh_rounded),
      ),
      body: Container(
        width: double.infinity,
        child: DataTable(
          columns: const <DataColumn>[
            DataColumn(
              label: Text(
                'Rack Number',
                style: TextStyle(
                    fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'Current Crop',
                style: TextStyle(
                    fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'Delete',
                style: TextStyle(
                    fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
              ),
            ),
          ],
          rows: <DataRow>[
            DataRow(
              cells: <DataCell>[
                DataCell(Text('Rack 1')),
                DataCell(Text(textSetValue(0))),
                DataCell(IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () => _deleteSetCrop('1'),
                )),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(Text('Rack 2')),
                DataCell(Text(textSetValue(1))),
                DataCell(IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () => _deleteSetCrop('2'),
                ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
