abstract class FamilyEvent {
}

class LoadFamilyEvent extends FamilyEvent {
  LoadFamilyEvent();
}


class UpdateFamilyEvent extends FamilyEvent {
  final double balance;
  UpdateFamilyEvent(this.balance);
}