import 'package:smart_lunch/data/models/classification_model.dart';

abstract class ClassificationState {
  const ClassificationState();
}

class ClassificationInitial extends ClassificationState {}

class ClassificationLoading extends ClassificationState {}

class ClassificationLoaded extends ClassificationState {
  final List<Classification> classifications;

  const ClassificationLoaded(this.classifications);
}

class ClassificationError extends ClassificationState {
  final String message;

  const ClassificationError(this.message);
}
