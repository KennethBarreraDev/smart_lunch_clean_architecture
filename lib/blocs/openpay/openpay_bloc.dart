import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_lunch/core/stages/app_stage.dart';
import 'package:smart_lunch/data/providers/openpay_provider.dart';

import 'package:smart_lunch/data/repositories/openpay/openpay_repository.dart';

import 'openpay_event.dart';
import 'openpay_state.dart';

class OpenpayBloc extends Bloc<OpenpayEvent, OpenpayState> {
  final OpenpayRepository repository;

  OpenpayBloc(this.repository) : super(OpenpayInitial()) {
    on<ConfigureOpenpayEvent>(_configureOpenpay);
  }

  Future<void> _configureOpenpay(
    OpenpayEvent event,
    Emitter<OpenpayState> emit,
  ) async {
    emit(OpenpayLoading());

    try {
      await repository.createOpenPayCustomer();
      Map<String, dynamic>? responseMap = await repository
          .getOpenPayCredentials();

      String merchantId = responseMap?["merchant_id"] ?? "";
      String publicKey = responseMap?["public_key"] ?? "";
      bool isProductionMode = AppStage.productionMode;

      Openpay openpay = Openpay(
        merchantId,
        publicKey,
        isProductionMode: isProductionMode,
      );

      await openpay.initializeOpenpay();

      Map<String, dynamic>? tutorResponseMap = await repository
          .getTutorOpenPayAccount();
      //TODO: add main card id to cards bloc
      String mainCardId = responseMap?["main_payment_token"] ?? "-1";
      String openpayId = responseMap?["openpay_id"] ?? "-1";

      repository.api.sessionRepository.setUserOpenpayId(openpayId);

      emit(OpenpayLoaded(openpay: openpay));
    } catch (e) {
      emit(OpenpayError(e.toString()));
    }
  }
}
