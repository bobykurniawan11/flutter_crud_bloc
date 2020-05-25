import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercrudbloc/server_response.dart';

import '../UserRepository.dart';

class UpdateBloc extends Bloc<UpdateEvent, UpdateState> {
  final UserRepository _userRepository;

  UpdateBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  UpdateState get initialState => InitialUpdateForm();

  @override
  Stream<UpdateState> mapEventToState(
    UpdateEvent event,
  ) async* {
    if (event is SubmitUpdate) {
      yield isSubmitting();
      try {
        ServerResponse status = await _userRepository.update(
            email: event.email, name: event.name, id: event.id);

        if (status != null && status.status != 1) {
          yield isFailure(status.message);
        } else {
          yield isSuccess();
        }

        // yield isSuccess();
      } catch (e) {
        yield isFailure(e.toString());
      }
    }
  }
}

abstract class UpdateEvent extends Equatable {
  const UpdateEvent();

  @override
  List<Object> get props => [];
}

class SubmitUpdate extends UpdateEvent {
  final String email;
  final String name;
  final String id;

  const SubmitUpdate(
      {@required this.email, @required this.name, @required this.id});

  @override
  List<Object> get props => [email, name];
}

abstract class UpdateState extends Equatable {
  const UpdateState();

  @override
  List<Object> get props => [];
}

class InitialUpdateForm extends UpdateState {}

class isSubmitting extends UpdateState {}

class isSuccess extends UpdateState {}

class isFailure extends UpdateState {
  final String message;

  isFailure(this.message);

  @override
  List<Object> get props => [message];
}
