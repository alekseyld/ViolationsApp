import 'package:flutter/material.dart';
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
              extendBodyBehindAppBar: true,
              body: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Stack(
                    children: <Widget>[
                      PageViewWithIndicator(
                        photoList: violation.images,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 380),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.0))),
                        padding: EdgeInsets.all(26.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text(
                              violation.title,
                              maxLines: 1,
                              style: textTheme.headline5,
                            ),
                            const SizedBox(height: 26),
                            Text(
                              "Описание:",
                              style: TextStyle(
                                  fontFamily: 'RobotoThin',
                                  fontStyle: FontStyle.italic),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              violation.description,
                              style: textTheme.bodyText2,
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 25,
                        left: 4,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back_outlined),
                          color: Colors.white,
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      )
                    ],
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
