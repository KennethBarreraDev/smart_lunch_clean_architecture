abstract class HomeState {
  final bool showMenu;

  const HomeState({required this.showMenu});
}

class HomeInitial extends HomeState {
  const HomeInitial() : super(showMenu: true);
}

class HomeMenuVisibilityChanged extends HomeState {
  const HomeMenuVisibilityChanged({required bool showMenu})
      : super(showMenu: showMenu);
}