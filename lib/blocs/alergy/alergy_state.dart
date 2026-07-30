import 'package:smart_lunch/data/models/alergy_model.dart';

abstract class AlergyState {
  const AlergyState();
}

class AlergyInitial extends AlergyState {}

class AlergyLoading extends AlergyState {}

class AlergyLoaded extends AlergyState {
  final List<Alergy> alergies;

  const AlergyLoaded(this.alergies);
}

class AlergyError extends AlergyState {
  final String message;

  const AlergyError(this.message);
}
