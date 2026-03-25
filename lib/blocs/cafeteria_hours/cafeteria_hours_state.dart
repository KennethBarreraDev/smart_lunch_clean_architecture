class CafeteriaHoursState {
  final DateTime currentDate;
  final DateTime cafeteriaCloseTime;
  final DateTime cafeteriaOpenTime;
  final List<String> clickableHours;
  final bool isOpen;


  CafeteriaHoursState({
    required this.currentDate,
    required this.cafeteriaCloseTime,
    required this.cafeteriaOpenTime,
    required this.clickableHours,
    this.isOpen = false,
  });

  CafeteriaHoursState copyWith({
    DateTime? currentDate,
    DateTime? cafeteriaCloseTime,
    DateTime? cafeteriaOpenTime,
    List<String>? clickableHours,
    bool? isOpen,
  }) {
    return CafeteriaHoursState(
      currentDate: currentDate ?? this.currentDate,
      cafeteriaCloseTime: cafeteriaCloseTime ?? this.cafeteriaCloseTime,
      cafeteriaOpenTime: cafeteriaOpenTime ?? this.cafeteriaOpenTime,
      clickableHours: clickableHours ?? this.clickableHours,
      isOpen: isOpen ?? this.isOpen,
    );
  }
}
