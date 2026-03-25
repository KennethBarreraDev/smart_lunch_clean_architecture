import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeInitial()) {
    on<ToggleMenuEvent>(_toggleMenu);
  }

  void _toggleMenu(
    ToggleMenuEvent event,
    Emitter<HomeState> emit,
  ) {
    emit(HomeMenuVisibilityChanged(showMenu: !state.showMenu));
  }

}