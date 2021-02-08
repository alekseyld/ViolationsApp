import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photocontrolapp/blocs/blocs.dart';
import 'package:photocontrolapp/models/models.dart';
import 'package:photocontrolapp/widgets/widgets.dart';

class DetailsScreen extends StatefulWidget {
  final Violation violation;
  final ViolationsBloc bloc;

  const DetailsScreen({Key key, this.violation, this.bloc}) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Scaffold(
              extendBodyBehindAppBar: true,
              body: BlocBuilder<ViolationsBloc, ViolationsState>(
                  bloc: widget.bloc,
                  builder: (context, state) {
                    final updatedViolation = (state as ViolationsLoadSuccess)
                        .violations
                        .firstWhere(
                            (element) => element.id == widget.violation.id);

                    return ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        Stack(
                          children: [
                            PageViewWithIndicator(
                              photoList: widget.violation.images,
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
                                children: [
                                  Text(
                                    widget.violation.title,
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
                                    widget.violation.description,
                                    style: textTheme.bodyText2,
                                  ),
                                ]
                                  ..addAll(_addCommentWidget(
                                      context, updatedViolation))
                                  ..addAll(_commentSection(
                                      context, updatedViolation)),
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
                    );
                  })),
        ],
      ),
    );
  }

  String _commentText = "";
  List<String> _attachFiles = [];
  final _textEditingController = TextEditingController();

  List<Widget> _addCommentWidget(
      BuildContext context, Violation updatedViolation) {
    return [
      const SizedBox(height: 26),
      Row(
        children: [
          Flexible(
            child: TextFormField(
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: "Комментарий",
                labelText: "Комментарий",
                hintStyle: TextStyle(fontSize: 14),
              ),
              style: TextStyle(fontSize: 14),
              controller: _textEditingController,
              onChanged: (value) => _commentText = value,
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            color: Theme.of(context).accentColor,
            iconSize: 30,
            onPressed: () {
              if (_attachFiles.isNotEmpty || _commentText.isNotEmpty) {
                final DateFormat formater = DateFormat('dd.MM.yyyy HH:mm');
                String date = formater.format(DateTime.now());

                updatedViolation.comments
                    .add(Comment(_commentText, _attachFiles, date));

                _textEditingController.clear();

                setState(() {
                  _commentText = "";
                  _attachFiles = [];

                  widget.bloc..add(ViolationUpdated(updatedViolation));
                });
              }
            },
          ),
        ],
      ),
      const SizedBox(height: 8),
      SizedBox(
        height: 60,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(vertical: 8),
          children: [
            GestureDetector(
              onTap: () async {
                _onAttachFile(updatedViolation);
              },
              child: Material(
                elevation: 1,
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: Colors.white,
                child: Container(
                  child: Icon(Icons.attach_file, color: Colors.black26),
                  height: 50,
                  width: 50,
                ),
              ),
            )
          ]..addAll(_attachFiles
              .map(
                (path) => Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Material(
                    elevation: 1,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Colors.white,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: Center(
                        child: Text(
                          basename(path),
                          maxLines: 1,
                          softWrap: true,
                        ),
                      ),
                      height: 50,
                    ),
                  ),
                ),
              )
              .toList()),
        ),
      ),
    ];
  }

  List<Widget> _commentSection(
      BuildContext context, Violation updatedViolation) {
    if (updatedViolation.comments.isEmpty) {
      return [];
    }

    return [
      const SizedBox(height: 16),
      Text(
        "Комментарии:",
        style: TextStyle(fontFamily: 'RobotoThin', fontStyle: FontStyle.italic),
        textAlign: TextAlign.start,
      ),
      const SizedBox(height: 16),
    ]..addAll(
        updatedViolation.comments.map((comment) {
          List<Widget> children = [
            Text(
              comment.date,
              style: TextStyle(
                fontSize: 11,
                fontStyle: FontStyle.italic,
                color: Colors.black38
              ),
            ),
          ];

          if (comment.text.isNotEmpty) {
            children.add(
              Text(comment.text),
            );
          }

          if (comment.attachedFiles.isNotEmpty) {
            children.add(SizedBox(
              height: 60,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(vertical: 8),
                children: comment.attachedFiles
                    .map(
                      (path) => GestureDetector(
                        onTap: () => OpenFile.open(path),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Material(
                            elevation: 1,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            color: Colors.white,
                            child: Container(
                              padding: EdgeInsets.all(8),
                              child: Center(
                                child: Text(
                                  basename(path),
                                  maxLines: 1,
                                  softWrap: true,
                                ),
                              ),
                              height: 50,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ));
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: Colors.black12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          );
        }),
      );
  }

  void _onAttachFile(Violation updatedViolation) async {
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path);

      final path = join(
        // Store the picture in the temp directory.
        // Find the temp directory using the `path_provider` plugin.
        (await getApplicationSupportDirectory()).path,
        basename(file.path),
      );

      await file.copy(path);

      setState(() {
        _attachFiles.add(path);
      });
    } else {
      // User canceled the picker

    }
  }
}
