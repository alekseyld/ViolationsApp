import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photocontrolapp/blocs/blocs.dart';
import 'package:photocontrolapp/screens/screens.dart';
import 'package:photocontrolapp/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Violation List"),
      ),
      body: ViolationList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) {
              return AddViolationScreen(onSave: (violation) {
                BlocProvider.of<ViolationsBloc>(context)
                  ..add(ViolationAdded(violation));
              });
            }),
          );
        },
      ),
    );
  }
}
