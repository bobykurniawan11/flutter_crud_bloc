import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../User.dart';
import '../UserRepository.dart';

class ReadBloc extends Bloc<ReadEvent, ReadState> {
  final UserRepository _userRepository;

  ReadBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  ReadState get initialState => InitialState();

  @override
  Stream<ReadState> mapEventToState(
    ReadEvent event,
  ) async* {
    if (event is FetchData) {
      yield isProcessing();
      try {
        final hasil = await _userRepository.read();
        if (hasil.toString().length > 0) {
          yield isSuccess(user: hasil);
        } else {
          yield isFailure("ada");
        }
      } catch (e) {
        yield isFailure(e.toString());
      }
    }
  }
}

abstract class ReadEvent extends Equatable {
  const ReadEvent();

  @override
  List<Object> get props => [];
}
class FetchData extends ReadEvent {}

abstract class ReadState extends Equatable {
  ReadState([List props = const []]) : super();
}

class InitialState extends ReadState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class isProcessing extends ReadState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class isSuccess extends ReadState {
 final List<User> user;

  isSuccess({@required this.user})
      : assert(user != null),
        super([user]);

  @override
  List<Object> get props => null;
}

class isFailure extends ReadState {
   String message;

  isFailure(this.message);

  @override
  List<Object> get props => [message];
}
