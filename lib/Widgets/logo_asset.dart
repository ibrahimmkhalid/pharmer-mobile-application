import 'package:flutter/material.dart';

class LogoAsset extends StatelessWidget {
  final String dir;

  LogoAsset(this.dir);

  @override
  Widget build(BuildContext context) {
    return Image(image: AssetImage(dir));
  }
}
