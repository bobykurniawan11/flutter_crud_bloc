import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercrudbloc/server_response.dart';

import '../UserRepository.dart';

class CreateBloc extends Bloc<CreateEvent, CreateState> {
  final UserRepository _userRepository;

  CreateBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  CreateState get initialState => InitialCreateForm();

  @override
  Stream<CreateState> mapEventToState(
    CreateEvent event,
  ) async* {
    if (event is SubmitInput) {
      yield isSubmitting();
      try {
        ServerResponse status = await _userRepository.create(
          email: event.email,
          name: event.name,
        );

        if (status != null && status.status != 1) {
          yield isFailure(status.message);
        } else {
          yield isSuccess();
        }

        // yield isSuccess();
      } catch (e) {
        print("Error coy");
        yield isFailure(e.toString());
      }
    }
  }
}

abstract class CreateEvent extends Equatable {
  const CreateEvent();

  @override
  List<Object> get props => [];
}

class SubmitInput extends CreateEvent {
  final String email;
  final String name;

  const SubmitInput({
    @required this.email,
    @required this.name,
  });

  @override
  List<Object> get props => [email, name];
}

abstract class CreateState extends Equatable {
  const CreateState();

  @override
  List<Object> get props => [];
}

class InitialCreateForm extends CreateState {}

class isSubmitting extends CreateState {}

class isSuccess extends CreateState {}

class isFailure extends CreateState {
  final String message;

  isFailure(this.message);

  @override
  List<Object> get props => [message];
}
