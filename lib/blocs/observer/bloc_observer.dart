import 'dart:developer';
import 'package:bloc/bloc.dart';

class MyBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    log(' Observer onCreate -- ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    log(' Observer onEvent -- ${bloc.runtimeType}, $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    log(' Observer onChange -- ${bloc.runtimeType}, $change');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    log(' Observer onTransition -- ${bloc.runtimeType}, $transition');
  }

  @override
  void onDone(Bloc bloc, Object? event, [Object? error, StackTrace? stackTrace]) {
    super.onDone(bloc, event, error, stackTrace);
    log(' Observer onDone -- ${bloc.runtimeType}, $event, $error');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log(' Observer onError -- ${bloc.runtimeType}, $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    log(' Observer onClose -- ${bloc.runtimeType}');
  }
}