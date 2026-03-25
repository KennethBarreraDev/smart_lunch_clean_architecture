import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_lunch/data/models/cafeteria_user_model.dart';
import 'package:smart_lunch/data/models/user_model.dart';
import 'package:smart_lunch/data/repositories/users/users_repository.dart';

import 'user_event.dart';
import 'users_state.dart';

class UsersBloc extends Bloc<UserEvent, UsersState> {
  final UserRepository repository;

  UsersBloc(this.repository) : super(UsersInitial()) {
    on<LoadUsersEvent>(_loadUsers);
  }

  Future<void> _loadUsers(UserEvent event, Emitter<UsersState> emit) async {
    emit(UsersLoading());

    try {
      final results = await Future.wait([
        repository.loadCurrentUser(),
        repository.loadUserChildren(),
        // repository.loadDebtorsChildren(),
      ]);

      final CafeteriaUser currentUser = results[0] as CafeteriaUser;
      final List<CafeteriaUser> children = results[1] as List<CafeteriaUser>;
      // final DebtorsResponse debtorsChildren = results[2] as DebtorsResponse;

      emit(
        UsersLoaded(
          mainUser: currentUser,
          children: children,
          debtUsers: [],
          totalDebt: 0,
        ),
      );
    } catch (e) {
      emit(UsersError(e.toString()));
    }
  }
}
