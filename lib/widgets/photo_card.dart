import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photocontrolapp/camera_holder.dart';
import 'package:photocontrolapp/widgets/widgets.dart';

class PhotoCard extends StatefulWidget {

  PhotoCard({Key key}) : super(key: key);

  @override
  PhotoCardState createState() => PhotoCardState();
}

class PhotoCardState extends State<PhotoCard> {


  List<String> photoPathList = [];

  void _navigateTakePicturePage(BuildContext context) async {
    String photoPath = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TakePicturePage(
            camera: CameraHolder().firstCamera,
          ),
        ));

    print("Photo Path = $photoPath");

    if (photoPath != null) {
      setState(() {
        photoPathList.add(photoPath);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        padding:
            const EdgeInsets.only(right: 16, left: 16, top: 27, bottom: 27),
        height: 180,
        child: ListView.builder(
          itemCount: photoPathList.length + 1,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            if (index == 0) {
              return GestureDetector(
                onTap: () => _navigateTakePicturePage(context),
                child: Container(
                  height: 125,
                  width: 125,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    color: Color(0xFFC4C4C4),
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            }

            return Container(
              height: 125,
              width: 125,
              margin: EdgeInsets.all(4.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Image.file(
                  File(photoPathList[index - 1]),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
