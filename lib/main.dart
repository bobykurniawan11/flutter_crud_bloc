import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercrudbloc/create/create_bloc.dart';
import 'package:fluttercrudbloc/create/create_form.dart';
import 'package:fluttercrudbloc/delete/delete_bloc.dart';
import 'package:fluttercrudbloc/read/read_bloc.dart';
import 'package:fluttercrudbloc/read/read_view.dart';

import 'UserRepository.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
      routes: <String, WidgetBuilder>{
        '/create': (BuildContext context) {
          return BlocProvider<CreateBloc>(
            create: (BuildContext context) =>
                CreateBloc(userRepository: userRepository),
            child: CreateForm(),
          );
        },
        '/read': (BuildContext context) {



          return
          MultiBlocProvider(
            providers: [
              BlocProvider<ReadBloc>(
                create: (BuildContext context) =>   ReadBloc(userRepository: userRepository),
              ),
              BlocProvider<DeleteBloc>(
                create: (BuildContext context) =>  DeleteBloc(userRepository: userRepository),
              ),
            ],
            child:  ReadView(),
          );
        },

      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("tukangaplikasi.com"),
      ),
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
            color: Colors.redAccent,
            child: Text("Form Input"),
            onPressed: () {
              Navigator.of(context).pushNamed('/create');
            },
          ),
          FlatButton(
            color: Colors.blueAccent,
            child: Text("List"),
            onPressed: () {
              Navigator.of(context).pushNamed('/read');
            },
          ),
        ],
      ),),
    );
  }
}
