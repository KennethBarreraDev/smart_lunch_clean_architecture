import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_lunch/blocs/selected_user/selected_user_bloc.dart';
import 'package:smart_lunch/blocs/selected_user/selected_user_state.dart';
import 'package:smart_lunch/core/base_widgets/input_text/label_input_text.dart';
import 'package:smart_lunch/core/utils/app_images.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';

class EditProfileTab extends StatefulWidget {
  const EditProfileTab({super.key});
  @override
  State<EditProfileTab> createState() => _EditProfileTabState();
}

class _EditProfileTabState extends State<EditProfileTab> {
  String _nameUserTextEdit = "";
  String _lastNameUserTextEdit = "";

  @override
  Widget build(BuildContext context) {
    final user = context.select((SelectedUserBloc bloc) {
      final state = bloc.state;
      if (state is SelectedUserDataLoaded) {
        return state.userData.user;
      }
      return null;
    });

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: (user.picture ?? '').isNotEmpty
                    ? NetworkImage(user.picture!)
                    : AssetImage(AppImages.defaultProfileStudentImage)
                          as ImageProvider,
              ),

              const SizedBox(height: 30),

              // TODO: Activar los inputs dejando readonly en false
              // actualmente en la api no actualiza los datos de usuarios como nombres
              LabelTextInput(
                label: AppLocalizations.of(context)!.user_name,
                initialValue: user.firstName ?? '',
                readOnly: true,
                onChanged: (String nuevoValor) {
                  _nameUserTextEdit = nuevoValor;
                },
              ),
              const SizedBox(height: 20),

              LabelTextInput(
                label: AppLocalizations.of(context)!.user_lastname,
                initialValue: user.lastName ?? '',
                readOnly: true,
                onChanged: (String nuevoValor) {
                  _lastNameUserTextEdit = nuevoValor;
                },
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed:
                      (_nameUserTextEdit.isEmpty ||
                          _lastNameUserTextEdit.isEmpty)
                      ? null
                      : () {
                          log(
                            "Guardando... Nombre: $_nameUserTextEdit, Apellido: $_lastNameUserTextEdit",
                          );
                        },
                  icon: const Icon(Icons.sync, size: 24),
                  label: Text(
                    AppLocalizations.of(context)!.save_button,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: const Color(0xFFE2F6F5),
                    foregroundColor: const Color(0xFF26BFC0),
                    disabledBackgroundColor: Colors.grey.shade300,
                    disabledForegroundColor: Colors.grey.shade600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}