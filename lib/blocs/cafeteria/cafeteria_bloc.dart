import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_lunch/core/constants/cache_keys.dart';
import 'package:smart_lunch/data/models/cafeteria_model.dart';
import 'package:smart_lunch/data/models/cafeteria_setting_model.dart';
import 'package:smart_lunch/data/providers/secure_storage_provider.dart';
import 'package:smart_lunch/data/repositories/cafeteria/cafeteria_repository.dart';

import 'cafeteria_event.dart';
import 'cafeteria_state.dart';

class CafeteriaBloc extends Bloc<CafeteriaEvent, CafeteriaState> {

  final CafeteriaRepository repository;
  final StorageProvider storage;

  CafeteriaBloc(
    this.repository,
    this.storage,
  ) : super(CafeteriaInitialState()) {

    on<LoadCafeteria>(_loadCafeteria);
  }

  Future<void> _loadCafeteria(
    LoadCafeteria event,
    Emitter<CafeteriaState> emit,
  ) async {

    emit(CafeteriaLoading());

    try {

      final List<Cafeteria> cafeterias = await repository.loadCafeterias();

      if (cafeterias.isEmpty) {
        emit(CafeteriaError("no_cafeterias_available"));
        return;
      }

      final cacheId = await storage.readValue(CacheKeys.cafeteriaId);
      developer.log("Cache id: $cacheId", name: "CafeteriaBloc");

      Cafeteria selected;

      if (cacheId.isNotEmpty &&
          cafeterias.any((c) => c.id == int.parse(cacheId))) {

        selected = cafeterias.firstWhere(
          (c) => c.id == int.parse(cacheId),
        );

      } else {

        selected = cafeterias.first;

      }

      developer.log("Selected cafeteria: ${selected.name}");

      await storage.writeValue(
        CacheKeys.cafeteriaId,
        selected.id.toString(),
      );

      final CafeteriaSetting cafeteriaSettings = await repository.loadCafeteriaSettings(selected.id.toString());


      emit(
        CafeteriaSuccess(
          cafeterias: cafeterias,
          selected: selected,
          cafeteriaSettings: cafeteriaSettings,
        ),
      );

    } catch (e) {
      emit(CafeteriaError(e.toString()));
    }
  }
}
