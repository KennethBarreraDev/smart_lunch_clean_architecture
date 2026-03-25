import 'package:smart_lunch/data/providers/openpay_provider.dart';

abstract class OpenpayState {}

class OpenpayInitial extends OpenpayState {}

class OpenpayLoading extends OpenpayState {}

class OpenpayLoaded extends OpenpayState {
  Openpay openpay;

  OpenpayLoaded({required this.openpay});
}

class OpenpayError extends OpenpayState {
  final String message;

  OpenpayError(this.message);
}