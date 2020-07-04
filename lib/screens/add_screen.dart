import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:photocontrolapp/models/models.dart';
import 'package:photocontrolapp/widgets/photo_card.dart';

typedef OnSaveCallback = Function(Violation violation);

class AddViolationScreen extends StatefulWidget {
  final OnSaveCallback onSave;

  const AddViolationScreen({Key key, this.onSave}) : super(key: key);

  @override
  _AddViolationScreenState createState() => _AddViolationScreenState();
}

class _AddViolationScreenState extends State<AddViolationScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static final GlobalKey<PhotoCardState> _photoCardKey = GlobalKey<PhotoCardState>();

  String _title;
  String _description;

  String _validateText(String value) {
    if (value.isEmpty) {
      return "Поле обязательно для заполнения";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    const sizedBoxSpace = SizedBox(height: 24);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Новое нарушение"),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            dragStartBehavior: DragStartBehavior.down,
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  "Вложенные изображения:",
                  style: textTheme.subtitle1,
                ),
                const SizedBox(height: 8.0,),
                PhotoCard(
                  key: _photoCardKey
                ),
                sizedBoxSpace,
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: "Краткий заголовок",
                    labelText: "Название нарушения",
                  ),
                  validator: _validateText,
                  onSaved: (value) {
                    _title = value;
                  },
                ),
                sizedBoxSpace,
                TextFormField(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: "Общая информация по поводу нарушения",
                    labelText: "Описание",
                  ),
                  maxLines: 4,
                  validator: _validateText,
                  onSaved: (value) {
                    _description = value;
                  },
                ),
                sizedBoxSpace,
                RaisedButton(
                  child: Text("СОЗДАТЬ"),
                  textColor: Colors.white,
                  color: Color(0xFF6200EE),
                  onPressed: () {
                    if (_photoCardKey.currentState.photoPathList.isNotEmpty) {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        widget.onSave(
                          Violation(
                            title: _title,
                            description: _description,
                            images: _photoCardKey.currentState.photoPathList
                          )
                        );
                        Navigator.pop(context);
                      }
                    } else {
                      //TODO: Make toast
                    }
                  },
                )
              ],
            ),
          ),
        ));
  }
}