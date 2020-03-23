import 'package:flutter/material.dart';
import 'package:fluttercovid19bloc/screen/covid19_map_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: Covid19MapScreen(),
    );
  }
}
