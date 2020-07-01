import 'package:flutter/material.dart';
import 'package:photocontrolapp/models/models.dart';

typedef OnSaveCallback = Function(Violation violation);

class AddViolationScreen extends StatefulWidget {
  final OnSaveCallback onSave;

  const AddViolationScreen({Key key, this.onSave}) : super(key: key);

  @override
  _AddViolationScreenState createState() => _AddViolationScreenState();
}

class _AddViolationScreenState extends State<AddViolationScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Новое нарушение"),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Вложенные изображения:",
                style: textTheme.subtitle1,
              ),
            ),
            Card(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
              ),
              margin: const EdgeInsets.only(
                top: 0,
                bottom: 0,
                left: 16,
                right: 16
              ),
              child: Container(
                padding: const EdgeInsets.only(
                    right: 16, left: 16, top: 27, bottom: 27),
                height: 180,
                child: ListView.builder(
                  itemCount: 5,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return GestureDetector(
                        onTap: () {
                          //TODO: Open Camera for photo
                        },
                        child: Container(
                          height: 125,
                          width: 125,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)
                            ),
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
                      child: Center(
                        child: Text("Icon"),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ));
  }
}

//Column(
//            children: <Widget>[
//              Container(
//                height: 180,
//                child: ListView(
//                  scrollDirection: Axis.horizontal,
//                  children: <Widget>[
//                    Container(
//                        width: 180,
//                        child: Card(
//                          color: Colors.white30,
//                          child: Center(
//                            child: Icon(
//                              Icons.add,
//                              size: 50,
//                            ),
//                          ),
//                        )),
//                    Container(
//                      padding: EdgeInsets.all(8.0),
//                      width: 180,
//                      child: Image.network(
//                        "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fi.ytimg.com%2Fvi%2FDt8y0l-n7ig%2Fmaxresdefault.jpg&f=1&nofb=1",
//                        fit: BoxFit.cover,
//                      ),
//                    ),
//                    Container(
//                      padding: EdgeInsets.all(8.0),
//                      width: 180,
//                      child: Image.network(
//                        "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fi.ytimg.com%2Fvi%2FDt8y0l-n7ig%2Fmaxresdefault.jpg&f=1&nofb=1",
//                        fit: BoxFit.cover,
//                      ),
//                    ),
//                    Container(
//                      padding: EdgeInsets.all(8.0),
//                      width: 180,
//                      child: Image.network(
//                        "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fi.ytimg.com%2Fvi%2FDt8y0l-n7ig%2Fmaxresdefault.jpg&f=1&nofb=1",
//                        fit: BoxFit.cover,
//                      ),
//                    ),
//                  ],
//                ),
//              ),
//
//            ],
//));

//              Form(
//                key: _formKey,
//                child: ListView(
//                  children: <Widget>[
//                    TextFormField(
//                      autofocus: true,
//                      style: textTheme.headline5,
//                      decoration: InputDecoration(
//                        hintText: "Заголовок",
//                      ),
//                      validator: (val) {
//                        return val.trim().isEmpty ? "Not Empty" : null;
//                      },
////                      onSaved: (value) => _task = value,
//                    ),
//                  ],
//                ),
//              ),
