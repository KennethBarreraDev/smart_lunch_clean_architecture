
import 'package:smart_lunch/data/models/cafeteria_model.dart';
import 'package:smart_lunch/data/models/cafeteria_setting_model.dart';

abstract class CafeteriaState {}

class CafeteriaInitialState extends CafeteriaState {}


class CafeteriaLoading extends CafeteriaState {}

class CafeteriaSuccess extends CafeteriaState {
  final List<Cafeteria> cafeterias;
  final CafeteriaSetting cafeteriaSettings;
  final Cafeteria selected;

  CafeteriaSuccess({
    required this.cafeterias,
    required this.selected,
    required this.cafeteriaSettings,
  });
}

class CafeteriaError extends CafeteriaState {
  final String message;

  CafeteriaError(this.message);
}
