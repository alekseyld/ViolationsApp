import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:photocontrolapp/models/models.dart';
import 'package:photocontrolapp/widgets/widgets.dart';

class DetailsScreen extends StatelessWidget {
  final Violation violation;

  const DetailsScreen({Key key, this.violation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  CarouselWithIndicator(
                    photoList: violation.images,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      violation.title,
                      maxLines: 1,
                      style: textTheme.headline5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Описание:",
                      style: TextStyle(fontStyle: FontStyle.italic),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      violation.description,
                      style: textTheme.bodyText2,
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
