import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:smart_lunch/data/models/app_version_model.dart';
import 'package:smart_lunch/data/repositories/app_version/app_version_repository.dart';
import 'app_version_event.dart';
import 'app_version_state.dart';

class AppVersionBloc extends Bloc<AppVersionEvent, AppVersionState> {
  final AppVersionRepository repository;

  AppVersionBloc(this.repository)
    : super(AppVersionInitialState()) {
    on<LoadAppversion>(_loadAppversion);
  }

  Future<void> _loadAppversion(
    LoadAppversion event,
    Emitter<AppVersionState> emit,
  ) async {
    emit(AppVersionLoading());

    try {
      final AppVersion appVersion = await repository.getLastAppVersion();


 
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String buildNumber = packageInfo.buildNumber;

      if (Platform.isAndroid) {
        if (appVersion.androidVersion == buildNumber) {
         emit(LastAppVersion());
        } else {
          emit(AppNotUpdated());
        }
      } else if (Platform.isIOS) {
        if (appVersion.iosVersion == buildNumber) {
          emit(LastAppVersion());
        } else {
          emit(AppNotUpdated());
        }
      }
    } catch (e) {
      emit(AppVersionError(e.toString()));
    }
  }
}
