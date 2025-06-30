import 'package:flutter_bloc/flutter_bloc.dart';

import 'MenuEvent.dart';
import 'MenuState.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc() : super(MenuState(0)) {
    on<MenuChangeEvent>((event, emit) {
      emit(MenuState(event.selectedIndex));
    });
  }
}
