import 'package:equatable/equatable.dart';

abstract class ChatbotEvent extends Equatable {
  const ChatbotEvent();

  @override
  List<Object?> get props => [];
}

class AddressRequested extends ChatbotEvent {
  final String query;

  const AddressRequested(this.query);

  @override
  List<Object?> get props => [query];
}
