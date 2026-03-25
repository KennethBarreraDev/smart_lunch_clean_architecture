abstract class FamilyState {}

class FamilyInitial extends FamilyState {}

class FamilyLoading extends FamilyState {}

class FamilyLoaded extends FamilyState {
  double balance;

  FamilyLoaded(this.balance);
}

class FamilyError extends FamilyState {
  final String message;

  FamilyError(this.message);
}