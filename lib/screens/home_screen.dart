import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photocontrolapp/blocs/blocs.dart';
import 'package:photocontrolapp/screens/screens.dart';
import 'package:photocontrolapp/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.assignment_late)),
              Tab(icon: Icon(Icons.assignment_turned_in_outlined)),
            ],
          ),
          title: Text('Нарушения'),
        ),
        body: TabBarView(
          children: [
            ViolationList(violationType: ViolationType.OPEN,),
            ViolationList(violationType: ViolationType.COMPLETE,),
          ],
        ),
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
      ),
    );
  }
}
