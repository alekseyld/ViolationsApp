import 'dart:io';

import 'package:flutter/material.dart';

class PageViewWithIndicator extends StatefulWidget {
  final List<String> photoList;

  const PageViewWithIndicator({Key key, this.photoList}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PageViewWithIndicatorState();
  }
}

class _PageViewWithIndicatorState extends State<PageViewWithIndicator> {
  int _current = 0;

  final controller = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = widget.photoList
        .map((item) => Container(
              child: Image.file(
                File(item),
                fit: BoxFit.cover,
              ),
            ))
        .toList();

    return Stack(children: [
      Container(
        height: 400,
        child: PageView(
          onPageChanged: (value) {
            setState(() {
              _current = value;
            });
          },
          controller: controller,
          scrollDirection: Axis.horizontal,
          children: imageSliders
        ),
      ),
      Positioned(
        bottom: 20,
        left: 0,
        right: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.photoList.map((url) {
            int index = widget.photoList.indexOf(url);
            return Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _current == index
                    ? Color.fromRGBO(0, 0, 0, 0.9)
                    : Color.fromRGBO(0, 0, 0, 0.4),
              ),
            );
          }).toList(),
        ),
      ),
    ]);
  }
}
