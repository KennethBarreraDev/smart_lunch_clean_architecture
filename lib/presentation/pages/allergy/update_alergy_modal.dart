import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_lunch/blocs/alergy/alergy_bloc.dart';
import 'package:smart_lunch/blocs/alergy/alergy_event.dart';
import 'package:smart_lunch/blocs/alergy/alergy_state.dart';
import 'package:smart_lunch/blocs/selected_user/selected_user_bloc.dart';
import 'package:smart_lunch/blocs/selected_user/selected_user_event.dart';
import 'package:smart_lunch/blocs/selected_user/selected_user_state.dart';
import 'package:smart_lunch/core/base_widgets/checkbox/custom_checkbox.dart';
import 'package:smart_lunch/core/base_widgets/input_text/label_input_text.dart';
import 'package:smart_lunch/core/base_widgets/modals/custom_modal.dart';
import 'package:smart_lunch/data/models/alergy_model.dart';
import 'package:smart_lunch/data/models/user_model.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';

// FORMATO DE ENTRADA ESPERADO:
// "ids: 1, 2, 3 | Personalized: texto personalizado"
// Si no viene nada o es ilegible, se usa formato por defecto sin información

// AppLocalizations.of(context)!.name

class UpdateAlergyModal extends StatefulWidget {
  final String? initialAlergies;

  const UpdateAlergyModal({super.key, this.initialAlergies});

  @override
  State<UpdateAlergyModal> createState() => _UpdateAlergyModalState();
}

class _UpdateAlergyModalState extends State<UpdateAlergyModal> {
  late List<Alergy> alergies;
  late Set<int> selectedAlergyIds;
  late TextEditingController personalizedController;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    selectedAlergyIds = {};
    personalizedController = TextEditingController();
    _loadAlergies();
  }

  @override
  void dispose() {
    personalizedController.dispose();
    super.dispose();
  }

  Future<void> _loadAlergies() async {
    try {
      final bloc = context.read<AlergyBloc>();
      final state = bloc.state;

      if (state is AlergyLoaded) {
        setState(() {
          alergies = state.alergies;
          isLoading = false;
        });
        _parseInitialDataIfNeeded();
      } else {
        bloc.add(LoadAlergies());

        await for (final newState in bloc.stream) {
          if (newState is AlergyLoaded) {
            setState(() {
              alergies = newState.alergies;
              isLoading = false;
            });
            _parseInitialDataIfNeeded();
            break;
          } else if (newState is AlergyError) {
            setState(() {
              errorMessage = newState.message;
              isLoading = false;
            });
            break;
          }
        }
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load allergies';
        isLoading = false;
      });
    }
  }

  void _parseInitialDataIfNeeded() {
    if (widget.initialAlergies != null && widget.initialAlergies!.isNotEmpty) {
      _parseInitialData(widget.initialAlergies!);
    }
  }

  void _parseInitialData(String initialData) {
    try {
      final parsed = UserModel.parseAllergyString(initialData);
      final ids = (parsed['ids'] as List).cast<int>();

      if (ids.isNotEmpty) {
        selectedAlergyIds = ids.toSet();
      }

      final personalized = parsed['personalized'] as String;
      if (personalized.isNotEmpty) {
        personalizedController.text = personalized;
      }

      setState(() {});
    } catch (e) {
      developer.log('Failed to parse initial data: $e');
      selectedAlergyIds = {};
      personalizedController.clear();
      setState(() {});
    }
  }

  void _toggleAlergy(int id) {
    setState(() {
      if (selectedAlergyIds.contains(id)) {
        selectedAlergyIds.remove(id);
      } else {
        selectedAlergyIds.add(id);
      }
    });
  }

  String _getSelectedInfo() {
    return UserModel.buildAllergyString({
      'ids': selectedAlergyIds.toList(),
      'personalized': personalizedController.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return CustomModal(
        title: AppLocalizations.of(context)!.allergies_message,
        content: const Center(child: CircularProgressIndicator()),
        buttonText: 'Close',
      );
    }

    if (errorMessage != null) {
      return CustomModal(
        title: AppLocalizations.of(context)!.allergies_message,
        content: Column(
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 40),
            const SizedBox(height: 8),
            Center(
              child: Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
        buttonText: 'Retry',
        onButtonPressed: () {
          setState(() {
            isLoading = true;
            errorMessage = null;
          });
          _loadAlergies();
        },
      );
    }

    return CustomModal(
      title: AppLocalizations.of(context)!.allergies_message,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: alergies.map((alergy) {
              return CustomCheckbox(
                value: selectedAlergyIds.contains(alergy.id),
                text: alergy.name,
                onTap: () => _toggleAlergy(alergy.id),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          LabelTextInput(
            label: AppLocalizations.of(context)!.other_allergies,
            initialValue: personalizedController.text,
            onChanged: (value) {
              personalizedController.text = value;
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
      buttonText: AppLocalizations.of(context)!.save_button,
      onButtonPressed: () async {
        final info = _getSelectedInfo();

        final selectedUserState = context.read<SelectedUserBloc>().state;
        int? cafeteriaUserId;

        if (selectedUserState is SelectedUserLoaded) {
          cafeteriaUserId = selectedUserState.cafeteriaUserId;
        } else if (selectedUserState is SelectedUserDataLoaded) {
          cafeteriaUserId = selectedUserState.userData.id;
        }

        if (cafeteriaUserId == null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.no_user_selected_message,
              ),
            ),
          );
          return;
        }

        final updateData = {'custom_allergy': info};

        try {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) =>
                const Center(child: CircularProgressIndicator()),
          );

          context.read<SelectedUserBloc>().add(
            UpdateSelectedUser(
              cafeteriaUserId: cafeteriaUserId,
              updatedData: updateData,
            ),
          );

          await for (final state in context.read<SelectedUserBloc>().stream) {
            if (state is SelectedUserUpdated) {
              Navigator.pop(context);

              // mensaje de éxito
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)!.updated_allergies_successfully),
                    backgroundColor: Colors.green,
                  ),
                );

                Navigator.pop(context, info);
              }
              break;
            } else if (state is SelectedUserError) {
              Navigator.pop(context);

              // mensaje de error
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)!.updated_allergies_error),
                    backgroundColor: Colors.red,
                  ),
                );
              }
              break;
            }
          }
        } catch (e) {
          Navigator.pop(context);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${AppLocalizations.of(context)!.error_message}: ${e.toString()}',
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
    );
  }
}
