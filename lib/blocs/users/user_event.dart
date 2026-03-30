abstract class UserEvent {}

class LoadUsersEvent extends UserEvent {
  final bool isPanama;

  LoadUsersEvent({required this.isPanama});
}


class ToggleMembershipDebtorsModalVisibillity extends UserEvent {
  final bool show;

  ToggleMembershipDebtorsModalVisibillity({required this.show});
}
