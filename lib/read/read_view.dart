import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercrudbloc/UserRepository.dart';
import 'package:fluttercrudbloc/delete/delete_bloc.dart';
import 'package:fluttercrudbloc/read/read_bloc.dart';
import 'package:fluttercrudbloc/update/update_bloc.dart' as updt;
import 'package:fluttercrudbloc/update/update_form.dart';

class ReadView extends StatefulWidget {
  @override
  _ReadViewState createState() => _ReadViewState();
}

class _ReadViewState extends State<ReadView> {
  ReadBloc _readBloc;
  DeleteBloc _deleteBloc;

  final userRepository = UserRepository();

  @override
  void initState() {
    _readBloc = BlocProvider.of<ReadBloc>(context);
    _readBloc.add(FetchData());

    _deleteBloc = BlocProvider.of<DeleteBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("tukangaplikasi.com"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: BlocBuilder<ReadBloc, ReadState>(
          builder: (context, state) {
            if (state is isSuccess) {
              return ListView.separated(
                separatorBuilder: (context, index) => Padding(
                  padding: EdgeInsets.all(10),
                  child: Divider(
                    height: 3,
                  ),
                ),
                itemCount: state.user.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onLongPress: () async {
                      await _deleteBloc.add(
                        DoDelete(id: state.user[index].id),
                      );

                      _readBloc.add(FetchData());
                    },
                    onTap: () {
                      navigateToEditForm(state.user[index]);
                    },
                    child: ListTile(
                      title: Text(state.user[index].email),
                      subtitle: Text(state.user[index].nama),
                    ),
                  );
                },
              );
            } else if (state is InitialState) {
              return CircularProgressIndicator();
            } else if (state is isProcessing) {
              return CircularProgressIndicator();
            } else if (state is isFailure) {
              return Text("Failed to insert read : " + state.message);
            } else {
              return Text("Failed to insert read : Unknown error");
            }
          },
        ),
      ),
    );
  }

  navigateToEditForm(user) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return BlocProvider<updt.UpdateBloc>(
            create: (BuildContext context) =>
                updt.UpdateBloc(userRepository: userRepository),
            child: UpdateForm(user: user),
          );
        },
      ),
    ).then((_) {
      _readBloc.add(FetchData());
    });
  }
}
