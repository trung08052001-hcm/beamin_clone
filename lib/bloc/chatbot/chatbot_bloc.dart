import 'package:flutter_bloc/flutter_bloc.dart';
import 'chatbot_event.dart';
import 'chatbot_state.dart';

class ChatbotBloc extends Bloc<ChatbotEvent, ChatbotState> {
  ChatbotBloc() : super(ChatbotInitial()) {
    on<AddressRequested>(_onAddressRequested);
  }

  Future<void> _onAddressRequested(AddressRequested event, Emitter<ChatbotState> emit) async {
    emit(ChatbotLoading());
    try {
      // Replace with real address logic
      await Future.delayed(const Duration(seconds: 1));
      final address = "Địa chỉ: " + event.query;
      emit(ChatbotAddressLoaded(address));
    } catch (e) {
      emit(ChatbotError(e.toString()));
    }
  }
}
