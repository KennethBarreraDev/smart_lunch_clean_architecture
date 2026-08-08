import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_lunch/blocs/selected_user/selected_user_bloc.dart';
import 'package:smart_lunch/blocs/selected_user/selected_user_event.dart';
import 'package:smart_lunch/blocs/selected_user/selected_user_state.dart';
import 'package:smart_lunch/core/base_widgets/input_text/label_input_text.dart';
import 'package:smart_lunch/core/base_widgets/modals/custom_modal.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';

class UpdateDailyLimitModal extends StatefulWidget {
  const UpdateDailyLimitModal({super.key});

  @override
  State<UpdateDailyLimitModal> createState() => _UpdateDailyLimitModalState();
}

class _UpdateDailyLimitModalState extends State<UpdateDailyLimitModal> {
  late double _limitValue;
  bool _unlimited = false;
  String _textFieldValue = '';

  @override
  void initState() {
    super.initState();
    _limitValue = 0.0;
    _textFieldValue = '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectedUserBloc, SelectedUserState>(
      builder: (context, state) {
        if (state is SelectedUserDataLoaded) {
          final currentUser = state.userData;

          if (_textFieldValue.isEmpty && _limitValue == 0.0) {
            _limitValue = currentUser.dailyLimit ?? 0.0;
            _unlimited = _limitValue == 9999;
            if (!_unlimited) {
              _textFieldValue = _limitValue.toString();
            }
          }

          return CustomModal(
            title: AppLocalizations.of(context)!.daily_limit,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(AppLocalizations.of(context)!.enter_amount),
                const SizedBox(height: 8),
                LabelTextInput(
                  key: ValueKey(_unlimited),
                  label: AppLocalizations.of(context)!.daily_limit,
                  initialValue: _textFieldValue,
                  isNumeric: true,
                  readOnly: _unlimited,
                  onChanged: (value) {
                    if (!_unlimited) {
                      _textFieldValue = value;
                      _limitValue =
                          double.tryParse(value) ??
                          currentUser.dailyLimit ??
                          0.0;
                    }
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: _unlimited,
                      onChanged: (value) {
                        setState(() {
                          _unlimited = value ?? false;
                          if (_unlimited) {
                            _limitValue = 9999;
                            _textFieldValue = '';
                          } else {
                            _limitValue = currentUser.dailyLimit ?? 0.0;
                            _textFieldValue = _limitValue.toString();
                          }
                        });
                      },
                    ),
                    Text(AppLocalizations.of(context)!.limit_message),
                  ],
                ),
              ],
            ),
            buttonText: AppLocalizations.of(context)!.save_button,
            onButtonPressed: () {
              if (!_unlimited && _limitValue < 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(context)!.negative_limit_message,
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              final finalValue = _unlimited
                  ? 9999
                  : double.parse(_limitValue.toStringAsFixed(2));

              final updateData = <String, dynamic>{'daily_limit': finalValue};

              context.read<SelectedUserBloc>().add(
                UpdateSelectedUser(
                  cafeteriaUserId: currentUser.id!,
                  updatedData: updateData,
                ),
              );

              Navigator.pop(context);
            },
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
