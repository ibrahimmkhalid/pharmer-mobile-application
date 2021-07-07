import 'package:pharmer/sensor_status_page.dart';
import 'package:flutter/material.dart';

import 'Widgets/logo_asset.dart';
import 'Widgets/green_button.dart';
import 'current_page.dart';
import 'crop_page.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LogoAsset("images/PHARMER.png"),
            SizedBox(
              width: 200.0,
              height: 40.0,
              child: GreenButton(
                buttonText: 'Show Current Crops',
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CurrentPage()),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: 200.0,
              height: 40.0,
              child: GreenButton(
                  buttonText: 'Show Available Crops',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CropPage()),
                    );
                  }),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: 200.0,
              height: 40.0,
              child: GreenButton(
                buttonText: 'View Sensor Status',
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SensorStatus()),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
