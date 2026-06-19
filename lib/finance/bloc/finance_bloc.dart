import 'package:bloc/bloc.dart';

part 'finance_event.dart';
part 'finance_state.dart';

class FinanceBloc extends Bloc<FinanceEvent, FinanceState> {
  FinanceBloc() : super(FinanceInitial()) {
    on<FinanceEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
