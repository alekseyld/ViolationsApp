import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photocontrolapp/models/models.dart';

class DetailsScreen extends StatelessWidget {
  final Violation violation;

  const DetailsScreen({Key key, this.violation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
            extendBodyBehindAppBar: true,
            body: Column(
              children: <Widget>[
                Image.file(File(violation.images[0]))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
