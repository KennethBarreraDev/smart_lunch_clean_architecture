import 'package:bloc/bloc.dart';
import 'package:smart_lunch/blocs/selected_user/selected_user_event.dart';
import 'package:smart_lunch/blocs/selected_user/selected_user_state.dart';
import 'package:smart_lunch/data/repositories/users/users_repository.dart';


class SelectedUserBloc extends Bloc<SelectedUserEvent, SelectedUserState> {
  final UserRepository repository;
  
  SelectedUserBloc(this.repository) : super(SelectedUserInitial()) {
    on<SelectUser>((event, emit) {
      emit(SelectedUserLoaded(cafeteriaUserId: event.cafeteriaUserId));
      add(LoadSelectedUserData(cafeteriaUserId: event.cafeteriaUserId));
    });
    
    on<LoadSelectedUserData>((event, emit) async {
      emit(SelectedUserLoading());
      try {

        final userData = await repository.loadUserById(event.cafeteriaUserId);
        emit(SelectedUserDataLoaded(userData: userData));
        
      } catch (e) {
        emit(SelectedUserError(e.toString()));
      }
    });

    on<UpdateSelectedUser>((event, emit) async {
      emit(SelectedUserUpdating());
      try {

        await repository.updateUserInfo(
          cafeteriaUserId: event.cafeteriaUserId,
          body: event.updatedData,
        );

        emit(SelectedUserUpdated(updatedUserData: event.updatedData));

        add(SelectUser(cafeteriaUserId: event.cafeteriaUserId));

      } catch (e) {
        emit(SelectedUserError(e.toString()));
      }
    });
    
    on<ClearSelectedUser>((event, emit) {
      emit(SelectedUserInitial());
    });
  }
}