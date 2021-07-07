import 'package:connectivity/connectivity.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SensorStatus extends StatefulWidget {
  @override
  _SensorStatusState createState() => _SensorStatusState();
}

class _SensorStatusState extends State<SensorStatus> {
  var rack1 = {
    "airHumidity": 0.0,
    "airTemp": 0.0,
    "soilMoisture": 0.0,
  };
  var rack2 = {
    "airHumidity": 0.0,
    "airTemp": 0.0,
    "soilMoisture": 0.0,
  };

  @override
  initState() {
    super.initState();
    _updateSensors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Sensor Status"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _updateSensors,
        backgroundColor: Colors.green,
        child: const Icon(Icons.refresh_rounded),
      ),
      body: Container(
        width: double.infinity,
        child: DataTable(
          columnSpacing: 10,
          showBottomBorder: true,
          headingRowHeight: 50,
          horizontalMargin: 10,
          columns: const <DataColumn>[
            DataColumn(
                label: Text(
              'Rack',
              style: TextStyle(
                  fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
            )),
            DataColumn(
              label: Text(
                'Air Moisture',
                style: TextStyle(
                    fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'Air Temp',
                style: TextStyle(
                    fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'Soil Moisture',
                style: TextStyle(
                    fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
              ),
            ),
          ],
          rows: <DataRow>[
            DataRow(
              cells: <DataCell>[
                DataCell(Text('1')),
                DataCell(Text(rack1["airHumidity"].toString() + "%")),
                DataCell(Text(rack1["airTemp"].toString() + "C")),
                DataCell(Text(rack1["soilMoisture"].toString() + "%")),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(Text('2')),
                DataCell(Text(rack2["airHumidity"].toString() + "%")),
                DataCell(Text(rack2["airTemp"].toString() + "C")),
                DataCell(Text(rack2["soilMoisture"].toString() + "%")),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _updateSensors() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      DatabaseReference fdb = FirebaseDatabase.instance.reference();
      childSetter(fdb, "airHumidity", 1, rack1);
      childSetter(fdb, "airTemp", 1, rack1);
      childSetter(fdb, "soilMoisture", 1, rack1);
      childSetter(fdb, "airHumidity", 2, rack2);
      childSetter(fdb, "airTemp", 2, rack2);
      childSetter(fdb, "soilMoisture", 2, rack2);
      final snackBar = SnackBar(
        content: Text('Refreshed!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final snackBar = SnackBar(content: Text('No Internet Connection!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void childSetter(DatabaseReference fdb, String child, int rackNum,
      Map<String, double> rack) {
    fdb.child("Sensor/Rack: $rackNum/$child").once().then(
      (DataSnapshot data) {
        setState(() {
          rack[child] = double.parse(data.value.toString());
        });
      },
    );
  }
}
