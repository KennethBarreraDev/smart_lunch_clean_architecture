import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:smart_lunch/blocs/cafeteria_hours/cafeteria_hours_bloc.dart';
import 'package:smart_lunch/blocs/cafeteria_hours/cafeteria_hours_state.dart';
import 'package:smart_lunch/core/constants/countries.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';
import 'package:smart_lunch/core/utils/date_utils.dart';
import 'package:smart_lunch/data/models/cafeteria_model.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';

class PresaleDateSelector extends StatefulWidget {
  const PresaleDateSelector({
    super.key,
    required this.onChangeSelectedDate,
    required this.cafeteria,
    required this.defaultText,
  });

  final Cafeteria? cafeteria;
  final void Function(DateTime date, String? scheduledHour)? onChangeSelectedDate;
  final String defaultText;

  @override
  State<PresaleDateSelector> createState() => _PresaleDateSelectorState();
}

class _PresaleDateSelectorState extends State<PresaleDateSelector> {
  late TextEditingController dateController;

  @override
  void initState() {
    super.initState();
    dateController = TextEditingController(text: widget.defaultText);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CafeteriaHoursBloc, CafeteriaHoursState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Text(
              AppLocalizations.of(context)!.delivery_date,
              style: const TextStyle(
                color: Colors.black26,
                fontWeight: FontWeight.w700,
                fontSize: 12.0,
                fontFamily: "Comfortaa",
              ),
            ),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: AppColors.darkBlue.withValues(alpha: 0.15),
                ),
                color: Colors.white,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GestureDetector(
                onTap: () {
                  bool isPanama = Countries.isPanama(
                    widget.cafeteria?.school?.country ?? "",
                  );

                  int weekDaySaleRestriction =
                      (isPanama && DateTime.now().hour > 12) ? 2 : 1;

                  DateTime now = DateTime.now().add(
                    Duration(days: weekDaySaleRestriction),
                  );

                  DateTime nextWeekDay = now;

                  if (now.weekday == DateTime.sunday) {
                    nextWeekDay = nextWeekDay.add(const Duration(days: 1));
                  } else if (now.weekday == DateTime.saturday) {
                    nextWeekDay = nextWeekDay.add(const Duration(days: 2));
                  } else if (now.weekday == DateTime.friday) {
                    if (isPanama && DateTime.now().hour > 12) {
                      nextWeekDay = nextWeekDay.add(const Duration(days: 4));
                    }
                  }

                  showDatePicker(
                    context: context,
                    initialDate: nextWeekDay,
                    firstDate: nextWeekDay,
                    lastDate: now.add(const Duration(days: 15)),
                    selectableDayPredicate: (DateTime val) =>
                        val.weekday != DateTime.saturday &&
                        val.weekday != DateTime.sunday,
                    locale: Locale(
                      AppLocalizations.of(context)?.localeName ?? "",
                    ),
                  ).then((value) {
                    final selected = value ?? now;
                    dateController.text = CustomDateUtils.formatDateForPresale(
                      selected,
                    );

                    widget.onChangeSelectedDate?.call(selected, null);
                  });
                },
                child: TextFormField(
                  enabled: false,
                  controller: dateController,
                  style: TextStyle(
                    color: AppColors.darkBlue,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                  decoration: const InputDecoration(border: InputBorder.none),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
