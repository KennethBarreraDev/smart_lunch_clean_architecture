import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_lunch/blocs/cafeteria_hours/cafeteria_hours_bloc.dart';
import 'package:smart_lunch/blocs/cafeteria_hours/cafeteria_hours_state.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';

class SaleTimeSelector extends StatelessWidget {
   SaleTimeSelector({super.key, required this.onChangeSelectedDate, required this.scheduledHour});
   final void Function(DateTime date, String? scheduledHour)? onChangeSelectedDate;
   final String? scheduledHour;
 

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.deliver_in_time,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black.withValues(alpha: 0.5),
              ),
            ),
            GestureDetector(
              onTap: () {
                _showPicker(context);
              },
              child: Container(
                width: 170,
                height: 45,
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Colors.black.withValues(alpha: 0.4),
                  ),
                ),
                child: Center(
                  child: Text(
                    scheduledHour ?? AppLocalizations.of(context)!.select_time,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.black.withValues(alpha: .4),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showPicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => SizedBox(
        width: 100.w,
        height: 250,
        child: BlocBuilder<CafeteriaHoursBloc, CafeteriaHoursState>(
          builder: (context, state) {
            List<String> items = state.clickableHours;
            return CupertinoPicker(
              backgroundColor: Colors.white,
              itemExtent: 30,
              scrollController: FixedExtentScrollController(initialItem: 1),
              children: List.generate(
                items.length,
                (index) => Center(
                  child: Text(
                    items[index],
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              onSelectedItemChanged: (value) {
                String selectedHour = items[value];

                var separatedTime = selectedHour.split(':');
                int hour = int.parse(separatedTime[0]);
                int minute = int.parse(separatedTime[1].split(" ")[0]);
                DateTime scheduledDate = DateFormat("dd/MM/yyyy HH:mm").parse(
                  DateFormat("dd/MM/yyyy HH:mm")
                      .format(
                        DateTime.now().add(
                          Duration(
                            hours: hour,
                            minutes: minute,
                          ),
                        ),
                      )
                      .toString(),
                );
                onChangeSelectedDate?.call(scheduledDate, selectedHour);
              },
            );
          },
        ),
      ),
    );
  }
}
