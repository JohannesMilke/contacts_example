import 'package:contacts_example/main.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(MyApp.title),
        ),
        body: Center(
          child: Text('HomePage', style: TextStyle(fontSize: 24)),
        ),
      );
}
