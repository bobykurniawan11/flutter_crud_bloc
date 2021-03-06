import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercrudbloc/create/create_bloc.dart';

class CreateForm extends StatefulWidget {
  @override
  _CreateFormState createState() => _CreateFormState();
}

class _CreateFormState extends State<CreateForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  CreateBloc _createBloc;

  @override
  void initState() {
    _createBloc = BlocProvider.of<CreateBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("tukangaplikasi.com"),
      ),
      body: Padding(
        padding: EdgeInsets.all(40.0),
        child: BlocBuilder<CreateBloc, CreateState>(
          builder: (context, state) {
            if (state is isSuccess) {
              return Center(
                child: Text("Input berhasil"),
              );
            } else if (state is InitialCreateForm) {
              return Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.email,
                            color: Colors.lightBlueAccent,
                          ),
                          labelText: 'Email',
                        ),
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        validator: validateEmail),
                    TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.person,
                            color: Colors.lightBlueAccent,
                          ),
                          labelText: 'Nama',
                        ),
                        autocorrect: false,
                        validator: validateName),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          RaisedButton(
                            color: Colors.lightBlueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                _createBloc.add(SubmitInput(
                                    name: _nameController.text,
                                    email: _emailController.text));
                              }
                            },
                            child: Text('Simpan'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is isSubmitting) {
              return CircularProgressIndicator();
            } else if (state is isFailure) {
              return Text("Failed to insert data :" + state.message);
            } else {
              return Text("Failed to insert data : Unknown error");
            }
          },
        ),
      ),
    );
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Format email salah';
    else
      return null;
  }

  String validateName(String value) {
    if (value.length < 1)
      return 'Wajib di isi';
    else
      return null;
  }
}
