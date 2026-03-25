abstract class CafeteriaHoursEvent {}

class TimeTicked extends CafeteriaHoursEvent {}

class UpdateCafeteriaHours extends CafeteriaHoursEvent {
  final DateTime closeTime;
  final DateTime openTime;

  UpdateCafeteriaHours(this.closeTime, this.openTime);
}
