import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photocontrolapp/models/models.dart';

class CardItem extends StatelessWidget {
  final GestureTapCallback onTap;
  final Violation violation;

  CardItem({this.violation, this.onTap, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Widget image = Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      clipBehavior: Clip.antiAlias,
      child: Image.file(
        File(violation.images[0]),
        fit: BoxFit.cover,
      ),
    );

    return GestureDetector(
      onTap: onTap,
      child: GridTile(
        footer: Material(
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(4))),
          clipBehavior: Clip.antiAlias,
          child: GridTileBar(
            backgroundColor: Colors.black45,
            title: Text(
                violation.title,
                maxLines: 1,
            ),
          ),
        ),
        child: image,
      ),
    );
  }
}
