import 'package:flutter_bloc/flutter_bloc.dart';

import 'layout_event.dart';
import 'layout_state.dart';

class LayoutBloc extends Bloc<LayoutEvent, LayoutState> {
  LayoutBloc() : super(LayoutState.initial()) {
    on<ChangeBottomNavIndex>(_changeBottomNavIndex);
  }

  void _changeBottomNavIndex(
      ChangeBottomNavIndex event,
      Emitter<LayoutState> emit,
      ) {
    if (state.bottomNavIndex != event.index) {
      emit(
        state.copyWith(
          status: LayoutStateStatus.changeBottomNavIndex,
          bottomNavIndex: event.index,
        ),
      );
    }
  }
}

