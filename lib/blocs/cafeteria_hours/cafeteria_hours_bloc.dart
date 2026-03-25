import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_lunch/blocs/cafeteria_hours/cafeteria_hours_event.dart';
import 'package:smart_lunch/blocs/cafeteria_hours/cafeteria_hours_state.dart';

class CafeteriaHoursBloc
    extends Bloc<CafeteriaHoursEvent, CafeteriaHoursState> {
  Timer? _timer;

  CafeteriaHoursBloc()
      : super(
          CafeteriaHoursState(
            currentDate: DateTime.now(),
            cafeteriaCloseTime:
                DateTime.now(),
            cafeteriaOpenTime: DateTime.now(),
            clickableHours: const [],
            isOpen: false,
          ),
        ) {
    on<TimeTicked>(_onTicked);
    on<UpdateCafeteriaHours>(_onUpdateHours);

    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      add(TimeTicked());
    });
  }

  void _onTicked(TimeTicked event, Emitter<CafeteriaHoursState> emit) {
    final now = DateTime.now();

    final isOpen = _calculateIsOpen(
      now,
      state.cafeteriaOpenTime,
      state.cafeteriaCloseTime,
    );

    emit(
      state.copyWith(
        currentDate: now,
        clickableHours:
            _getClickableHours(now, state.cafeteriaCloseTime),
        isOpen: isOpen,
      ),
    );
  }

  void _onUpdateHours(
      UpdateCafeteriaHours event, Emitter<CafeteriaHoursState> emit) {
    final now = state.currentDate;

    final isOpen = _calculateIsOpen(
      now,
      event.openTime,
      event.closeTime,
    );

    emit(
      state.copyWith(
        cafeteriaOpenTime: event.openTime,
        cafeteriaCloseTime: event.closeTime,
        clickableHours:
            _getClickableHours(now, event.closeTime),
        isOpen: isOpen,
      ),
    );
  }

  bool _calculateIsOpen(
    DateTime now,
    DateTime openTime,
    DateTime closeTime,
  ) {
    return now.isAfter(openTime) &&
        now.isBefore(closeTime) &&
        now.weekday != DateTime.saturday &&
        now.weekday != DateTime.sunday;
  }

  List<String> _getClickableHours(
      DateTime currentDate, DateTime closeTime) {
    int differenceInMinutes =
        closeTime.difference(currentDate).inMinutes;

    if (differenceInMinutes <= 0) return [];

    List<String> clickableHours = [];
    int currentHour = 0;
    String hourSuffix = "minutos";
    bool isGreaterThanHour = false;

    while (differenceInMinutes > 60) {
      if (!isGreaterThanHour) isGreaterThanHour = true;

      String prefix =
          currentHour < 10 ? "0$currentHour" : "$currentHour";

      clickableHours.add("$prefix:05 $hourSuffix");
      clickableHours.add("$prefix:10 $hourSuffix");
      clickableHours.add("$prefix:15 $hourSuffix");
      clickableHours.add("$prefix:30 $hourSuffix");
      clickableHours.add("$prefix:45 $hourSuffix");
      clickableHours.add(
        "${currentHour < 9 ? "0${currentHour + 1}" : currentHour + 1}:00 $hourSuffix",
      );

      currentHour++;
      differenceInMinutes -= 60;
      hourSuffix = "hrs";
    }

    hourSuffix = isGreaterThanHour ? "hrs" : "minutos";

    if (differenceInMinutes <= 60) {
      String prefix =
          currentHour < 10 ? "0$currentHour" : "$currentHour";

      if (differenceInMinutes >= 5) {
        clickableHours.add("$prefix:05 $hourSuffix");
      }
      if (differenceInMinutes >= 10) {
        clickableHours.add("$prefix:10 $hourSuffix");
      }
      if (differenceInMinutes >= 15) {
        clickableHours.add("$prefix:15 $hourSuffix");
      }
      if (differenceInMinutes >= 30) {
        clickableHours.add("$prefix:30 $hourSuffix");
      }
      if (differenceInMinutes >= 45) {
        clickableHours.add("$prefix:45 $hourSuffix");
      }
    }

    return clickableHours;
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}