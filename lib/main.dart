import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photocontrolapp/blocs/blocs.dart';
import 'package:photocontrolapp/blocs/simple_bloc_delegate.dart';
import 'package:photocontrolapp/camera_holder.dart';
import 'package:photocontrolapp/repositories/repositories.dart';
import 'package:photocontrolapp/screens/screens.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  CameraHolder().initCameras();
  runApp(RepositoryProvider<ViolationsRepository>(
      create: (context) => ViolationsRepository(),
      child: BlocProvider(
          create: (context) => ViolationsBloc(
              violationsRepository: RepositoryProvider.of(context))
            ..add(ViolationsLoaded()),
          child: ViolationsApp())));
}

class ViolationsApp extends StatelessWidget {

  ViolationsApp() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CardList',
      theme: ThemeData(
        primarySwatch: Colors.green,
        accentColor: Colors.blueAccent,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}
