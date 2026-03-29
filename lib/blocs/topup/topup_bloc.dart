import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_lunch/core/utils/topup_responses.dart';
import 'package:smart_lunch/data/repositories/topup/topup_repository.dart';

import 'topup_event.dart';
import 'topup_state.dart';

class TopupBloc extends Bloc<TopupEvent, TopupState> {
  final TopupRepository repository;

  TopupBloc(this.repository) : super(InitialTopupState()) {
    on<ConfigureTopupEvent>(_configureTopup);
    on<ResetTopupEvent>(_resetTopup);
    on<ProcessTopupEvent>(_processTopup);
    on<ChangeRechargeAmountEvent>(_changeRechargeAmount);
    on<ChangeSetTopupFromInputEvent>(_changeSetTopupFromInput);
    on<ChangeSelectedButtonIndexEvent>(_changeSelectedButtonIndex);
    on<ChangeInsertedAmountErrorEvent>(_changeInsertedAmountError);
    on<TopupBalanceEvent>(_topupWithOpenpay);
  }

  Future<void> _topupWithOpenpay(
    TopupBalanceEvent event,
    Emitter<TopupState> emit,
  ) async {
    emit(state.copyWith(processingTopup: true));

    final response = await repository.topupBalance(
      userBuyer: event.userBuyer,
      amount: event.amount,
      selectedMethod: event.allowedTopupMethods,
      cardId: event.cardId,
      deviceSessionID: event.deviceSessionID,
      cvv: event.cvv,
      tokenizedCard: event.tokenizedCard,
    );

    if (response.containsKey("status")) {
      if (response["status"] == TopupResponses.regularOpenpayResponse) {
        emit(
          TopupSuccessState(
            topUpId: response["rechargeFolio"],
            transactionFolio: response["platformFolio"],
            transactionStatus: response["transactionStatus"],
            minimunRechargeAmount: state.minimunRechargeAmount,
            selectedRechargeAmount: state.selectedRechargeAmount,
            commissionFee: state.commissionFee,
            processingTopup: false,
            chargeCommissionToParent: state.chargeCommissionToParent,
            commissionType: state.commissionType,
            selectedButtonIndex: state.selectedButtonIndex,
            setTopupFromInput: state.setTopupFromInput,
            insertedAmountError: state.insertedAmountError,
            selectedMethod: event.allowedTopupMethods,
          ),
        );
      } else if (response["status"] == TopupResponses.open3dSecure) {
        //TODO: Manage 3d secure response
      } else if (response["status"] == TopupResponses.openMercadoPago) {
        //TODO: Manage mercado pago response
      } else if (response["status"] == TopupResponses.error) {
        TopupErrorState(
          minimunRechargeAmount: state.minimunRechargeAmount,
          selectedRechargeAmount: state.selectedRechargeAmount,
          commissionFee: state.commissionFee,
          processingTopup: false,
          chargeCommissionToParent: state.chargeCommissionToParent,
          commissionType: state.commissionType,
          selectedButtonIndex: state.selectedButtonIndex,
          setTopupFromInput: state.setTopupFromInput,
          insertedAmountError: state.insertedAmountError,
        );
      }
    } else {
      emit(
        TopupErrorState(
          minimunRechargeAmount: state.minimunRechargeAmount,
          selectedRechargeAmount: state.selectedRechargeAmount,
          commissionFee: state.commissionFee,
          processingTopup: false,
          chargeCommissionToParent: state.chargeCommissionToParent,
          commissionType: state.commissionType,
          selectedButtonIndex: state.selectedButtonIndex,
          setTopupFromInput: state.setTopupFromInput,
          insertedAmountError: state.insertedAmountError,
        ),
      );
    }
  }

  void _changeInsertedAmountError(
    ChangeInsertedAmountErrorEvent event,
    Emitter<TopupState> emit,
  ) {
    emit(state.copyWith(insertedAmountError: event.insertedAmountError));
  }

  void _changeSelectedButtonIndex(
    ChangeSelectedButtonIndexEvent event,
    Emitter<TopupState> emit,
  ) {
    emit(state.copyWith(selectedButtonIndex: event.selectedButtonIndex));
  }

  void _changeSetTopupFromInput(
    ChangeSetTopupFromInputEvent event,
    Emitter<TopupState> emit,
  ) {
    emit(state.copyWith(setTopupFromInput: event.setTopupFromInput));
  }

  void _changeRechargeAmount(
    ChangeRechargeAmountEvent event,
    Emitter<TopupState> emit,
  ) {
    emit(state.copyWith(selectedRechargeAmount: event.selectedRechargeAmount));
  }

  void _processTopup(ProcessTopupEvent event, Emitter<TopupState> emit) {
    emit(state.copyWith(processingTopup: event.processingTopup));
  }

  void _configureTopup(ConfigureTopupEvent event, Emitter<TopupState> emit) {
    emit(
      TopupState(
        minimunRechargeAmount: event.minimunRechargeAmount,
        selectedRechargeAmount: event.selectedRechargeAmount,
        commissionFee: event.commissionFee,
        processingTopup: event.processingTopup,
        chargeCommissionToParent: event.chargeCommissionToParent,
        commissionType: event.commissionType,
      ),
    );
  }

  void _resetTopup(ResetTopupEvent event, Emitter<TopupState> emit) {
    emit(InitialTopupState());
  }
}
