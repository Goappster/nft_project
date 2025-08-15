import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ChipFilterEvent {}

class ChipSelected extends ChipFilterEvent {
  final int selectedIndex;
  ChipSelected(this.selectedIndex);
}

class ChipFilterState {
  final int selectedIndex;

  ChipFilterState({required this.selectedIndex});

  ChipFilterState copyWith({int? selectedIndex}) {
    return ChipFilterState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }
}

class ChipFilterBloc extends Bloc<ChipFilterEvent, ChipFilterState> {
  ChipFilterBloc() : super(ChipFilterState(selectedIndex: 0)) {
    on<ChipSelected>((event, emit) {
      emit(state.copyWith(selectedIndex: event.selectedIndex));
      // Trigger data update here based on selected filter
      print("Selected index: ${event.selectedIndex}");
    });
  }
}
