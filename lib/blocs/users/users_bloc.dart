import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_lunch/data/models/cafeteria_user_model.dart';
import 'package:smart_lunch/data/repositories/users/users_repository.dart';

import 'user_event.dart';
import 'users_state.dart';

class UsersBloc extends Bloc<UserEvent, UsersState> {
  final UserRepository repository;

  UsersBloc(this.repository) : super(UsersInitial()) {
    on<LoadUsersEvent>(_loadUsers);
    on<ToggleMembershipDebtorsModalVisibillity>(_toggleModalVisibillity);
  }

  void _toggleModalVisibillity(
    ToggleMembershipDebtorsModalVisibillity event,
    Emitter<UsersState> emit,
  ) {
    if (state is UsersLoaded) {
      emit((state as UsersLoaded).copyWith(showMembershipModal: event.show));
    }
  }

  Future<void> _loadUsers(
    LoadUsersEvent event,
    Emitter<UsersState> emit,
  ) async {
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

      bool hasPendingUserMemberships = false;
      List<CafeteriaUser> pendingUserMembershipUsers = [];

      if (children.isNotEmpty && event.isPanama) {
        final membershipUsers = children
            .where(
              (user) =>
                  user.membership == true && user.membershipExpiration != null,
            )
            .toList();

        final currentDate = DateTime.now();

        hasPendingUserMemberships = membershipUsers.any(
          (child) =>
              child.membership == true &&
              DateTime.parse(child.membershipExpiration!).isAfter(currentDate),
        );
        pendingUserMembershipUsers = membershipUsers
            .where(
              (child) => DateTime.parse(
                child.membershipExpiration!,
              ).isAfter(currentDate),
            )
            .toList();
      }

      emit(
        UsersLoaded(
          mainUser: currentUser,
          children: children,
          debtUsers: [],
          totalDebt: 0,
          hasPendingUserMemberships: hasPendingUserMemberships,
          pendingUserMemberships: pendingUserMembershipUsers,
          showMembershipModal: hasPendingUserMemberships,
        ),
      );
    } catch (e) {
      emit(UsersError(e.toString()));
    }
  }
}
