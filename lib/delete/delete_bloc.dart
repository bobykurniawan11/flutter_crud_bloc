import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercrudbloc/server_response.dart';

import '../UserRepository.dart';

class DeleteBloc extends Bloc<DeleteEvent, DeleteState> {
  final UserRepository _userRepository;

  DeleteBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  DeleteState get initialState => InitialDelete();

  @override
  Stream<DeleteState> mapEventToState(
    DeleteEvent event,
  ) async* {
    if (event is DoDelete) {
      try {
        ServerResponse status = await _userRepository.delete(id: event.id);
        if (status != null && status.status != 1) {
          yield deleteFailed(status.message);
        } else {
          yield deleteSuccess();
        }
      } catch (e) {
        yield deleteFailed(e.toString());
      }
    }
  }
}

abstract class DeleteEvent extends Equatable {
  const DeleteEvent();

  @override
  List<Object> get props => [];
}

class DoDelete extends DeleteEvent {
  final String id;

  const DoDelete({@required this.id});
}

abstract class DeleteState extends Equatable {
  const DeleteState();

  @override
  List<Object> get props => [];
}

class InitialDelete extends DeleteState {}

class isDeletting extends DeleteState {}

class deleteSuccess extends DeleteState {}

class deleteFailed extends DeleteState {
  final String message;

  deleteFailed(this.message);

  @override
  List<Object> get props => [message];
}
