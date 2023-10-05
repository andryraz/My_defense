import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loader extends StatelessWidget {
  const Loader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpinKitFoldingCube(
      color: Colors.redAccent,
      size: 50.0,
      duration: Duration(milliseconds: 1200),
    );
  }
}
