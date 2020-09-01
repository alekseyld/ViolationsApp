import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photocontrolapp/blocs/blocs.dart';
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
        child: Stack(
          fit: StackFit.expand,
          children: [
            image,
            Positioned(
              child: GestureDetector(
                onTap: () {
                  showDialog<void>(
                    context: context,
                    barrierDismissible: false, // user must tap button!
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Подтверждение действия'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Text(violation.isComplete
                                  ? "Подтвердите удаление нарушения"
                                  : "Подтвердите исправление нарушения"),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Нет'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          FlatButton(
                            child: Text('Да'),
                            onPressed: () {
                              BlocProvider.of<ViolationsBloc>(context)
                                ..add(violation.isComplete
                                    ? ViolationDeleted(violation)
                                    : ViolationCompleted(violation));
                              
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Icon(
                  violation.isComplete
                      ? Icons.delete_forever
                      : Icons.assignment_turned_in,
                  color: Colors.white60,
                  size: 30,
                ),
              ),
              top: 16.0,
              right: 16.0,
            )
          ],
        ),
      ),
    );
  }
}
