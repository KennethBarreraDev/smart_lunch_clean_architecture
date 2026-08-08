import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_lunch/blocs/app_version/app_version_bloc.dart';
import 'package:smart_lunch/blocs/app_version/app_version_state.dart';
import 'package:smart_lunch/blocs/cafeteria/cafeteria_bloc.dart';
import 'package:smart_lunch/blocs/cafeteria/cafeteria_state.dart';
import 'package:smart_lunch/blocs/users/user_event.dart';
import 'package:smart_lunch/blocs/users/users_bloc.dart';
import 'package:smart_lunch/blocs/users/users_state.dart';
import 'package:smart_lunch/core/base_widgets/appbar/custom_appbar.dart';
import 'package:smart_lunch/core/base_widgets/input_text/label_input_text.dart';
import 'package:smart_lunch/core/base_widgets/scaffold/transparent_scaffold.dart';
import 'package:smart_lunch/core/base_widgets/snackbar/generic_snackbar.dart';
import 'package:smart_lunch/core/constants/countries.dart';
import 'package:smart_lunch/core/utils/app_images.dart';
import 'package:smart_lunch/data/models/cafeteria_user_model.dart';
import 'package:smart_lunch/data/repositories/users/users_repository.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';

class UserInformationPage extends StatelessWidget {
  const UserInformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AppVersionBloc, AppVersionState>(
          listener: (context, state) {
            //TODO: Show version modal
            /*
            showDialog(
              context: context,
              useSafeArea: true,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return const AppVersionModal();
              },
            );*/
          },
        ),
      ],
      child: TransparentScaffold(
        selectedOption: "Ajustes",
        body: Stack(
          children: [
            Column(
              children: [
                CustomAppBar(
                  height: 120,
                  image: AppImages.cardImg,
                  showPageTitle: true,
                  pageTitle: AppLocalizations.of(context)!.my_information,
                  showDrawer: false,
                  showSchoolLogo: false,
                  hideGoBackText: false,
                  titleAlignment: Alignment.bottomLeft,
                  titleTopPadding: 0.4,
                  titleSize: 28.0,
                ),

                Expanded(
                  child: BlocBuilder<UsersBloc, UsersState>(
                    builder: (context, state) {
                      if (state is! UsersLoaded) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return _UserInformationForm(
                        key: ValueKey(state.mainUser.id),
                        user: state.mainUser,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _UserInformationForm extends StatefulWidget {
  const _UserInformationForm({super.key, required this.user});

  final CafeteriaUser user;

  @override
  State<_UserInformationForm> createState() => _UserInformationFormState();
}

class _UserInformationFormState extends State<_UserInformationForm> {
  late String _firstName = widget.user.user?.firstName ?? "";
  late String _lastName = widget.user.user?.lastName ?? "";
  late String _phone = widget.user.user?.phone ?? "";
  bool _saving = false;

  bool get _canSave =>
      _firstName.trim().isNotEmpty &&
      _lastName.trim().isNotEmpty &&
      _phone.trim().isNotEmpty &&
      !_saving;

  Future<void> _handleSave() async {
    final cafeteriaUserId = widget.user.id;
    if (cafeteriaUserId == null) return;

    setState(() => _saving = true);

    try {
      await context.read<UserRepository>().updateMainUserProfile(
        cafeteriaUserId: cafeteriaUserId,
        firstName: _firstName.trim(),
        lastName: _lastName.trim(),
        phone: _phone.trim(),
      );

      if (!mounted) return;

      final cafeteriaState = context.read<CafeteriaBloc>().state;
      context.read<UsersBloc>().add(
        LoadUsersEvent(
          isPanama: cafeteriaState is CafeteriaSuccess
              ? Countries.isPanama(
                  cafeteriaState.selected.school?.country ?? "",
                )
              : false,
        ),
      );

      showCustomSnackBar(
        context: context,
        bannerType: BannerTypes.successBanner.type,
        bannerMessage: AppLocalizations.of(context)!.data_updated_successfully,
      );
    } catch (e) {
      if (!mounted) return;

      showCustomSnackBar(
        context: context,
        bannerType: BannerTypes.errorBanner.type,
        bannerMessage: AppLocalizations.of(context)!.data_update_error,
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user.user;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: (user?.picture ?? '').isNotEmpty
                ? NetworkImage(user!.picture!)
                : AssetImage(AppImages.defaultProfileStudentImage)
                    as ImageProvider,
          ),

          const SizedBox(height: 30),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFEDEFF1)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabelTextInput(
                  label: AppLocalizations.of(context)!.user_name,
                  initialValue: _firstName,
                  onChanged: (value) => setState(() => _firstName = value),
                ),
                const SizedBox(height: 20),

                LabelTextInput(
                  label: AppLocalizations.of(context)!.user_lastname,
                  initialValue: _lastName,
                  onChanged: (value) => setState(() => _lastName = value),
                ),
                const SizedBox(height: 20),

                LabelTextInput(
                  label: AppLocalizations.of(context)!.phone_numer,
                  initialValue: _phone,
                  onChanged: (value) => setState(() => _phone = value),
                ),
                const SizedBox(height: 20),

                LabelTextInput(
                  label: AppLocalizations.of(context)!.email,
                  initialValue: user?.email ?? "",
                  readOnly: true,
                ),
                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _canSave ? _handleSave : null,
                    icon: _saving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.sync, size: 24),
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
        ],
      ),
    );
  }
}
