import 'package:flutter/material.dart';

class CropInputDialog extends StatelessWidget {
  final Function addCrop;
  final nameController = TextEditingController();
  final subTextController = TextEditingController();
  final airHumidityController = TextEditingController();
  final soilMoistureController = TextEditingController();
  final airTempController = TextEditingController();

  CropInputDialog(this.addCrop);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add a New Crop"),
      content: Container(
        height: 240, // Change as per your requirement
        width: 300.0,
        child: ListView(
          children: [
            TextField(
              decoration: InputDecoration(hintText: "Crop Name"),
              controller: nameController,
            ),
            TextField(
              decoration: InputDecoration(hintText: "Sub Text"),
              controller: subTextController,
            ),
            TextField(
              decoration:
                  InputDecoration(hintText: "Air Humidity Requirements"),
              keyboardType: TextInputType.number,
              controller: airHumidityController,
            ),
            TextField(
              decoration:
                  InputDecoration(hintText: "Soil Moisture Requirements"),
              keyboardType: TextInputType.number,
              controller: soilMoistureController,
            ),
            TextField(
              decoration:
                  InputDecoration(hintText: "Air Temperature Requirements"),
              keyboardType: TextInputType.number,
              controller: airTempController,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            addCrop(
              nameController.text,
              subTextController.text,
              double.parse(soilMoistureController.text),
              double.parse(airHumidityController.text),
              double.parse(airTempController.text),
            );
            Navigator.pop(context);
          },
          child: Text("Add Crop To List"),
        )
      ],
    );
  }
}
