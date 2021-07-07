import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget cropContainer(
    iconPath, name, subText, water, airHumidity, airTemp, deleteCrop, setCrop) {
  return Container(
    height: 110,
    decoration: BoxDecoration(
      border: Border(
        top: BorderSide(width: 1.0, color: Colors.greenAccent),
        bottom: BorderSide(
          width: 1.0,
          color: Colors.greenAccent,
        ),
      ),
    ),
    margin: EdgeInsets.all(5),
    child: CropCard(iconPath, name, subText, water, airHumidity, airTemp,
        deleteCrop, setCrop),
  );
}

class CropCard extends StatefulWidget {
  @override
  _CropCardState createState() => new _CropCardState();

  CropCard(this.fruitFile, this.name, this.sub, this.water, this.airHumidity,
      this.airTemp, this.deleteCrop, this.setCrop);

  final deleteCrop;
  final setCrop;
  final String fruitFile;
  final String name;
  final String sub;
  final double water;
  final double airHumidity;
  final double airTemp;
}

class _CropCardState extends State<CropCard> {
  var rackNumber = 1;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Center(
        child: ListTile(
          leading: new Image.asset(widget.fruitFile, width: 50, height: 60),
          title: Text(
            widget.name,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            widget.sub,
            style: TextStyle(color: Colors.grey),
          ),
          trailing: Container(
            width: 170,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<int>(
                  value: rackNumber,
                  style: const TextStyle(color: Colors.black),
                  underline: Container(
                    height: 2,
                    color: Colors.lightGreen,
                  ),
                  onChanged: (int? newValue) {
                    setState(() {
                      rackNumber = newValue!;
                      print(newValue);
                    });
                  },
                  items: <int>[1, 2].map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text("Rack: $value"),
                    );
                  }).toList(),
                ),
                Expanded(
                  flex: 3,
                  child: TextButton(
                    child: const Text('Select'),
                    onPressed: () => widget.setCrop(rackNumber, widget.name,
                        widget.water, widget.airHumidity, widget.airTemp),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () => widget.deleteCrop(widget.name),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
