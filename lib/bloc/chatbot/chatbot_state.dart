import 'package:equatable/equatable.dart';

abstract class ChatbotState extends Equatable {
  const ChatbotState();

  @override
  List<Object?> get props => [];
}

class ChatbotInitial extends ChatbotState {}

class ChatbotLoading extends ChatbotState {}

class ChatbotAddressLoaded extends ChatbotState {
  final String address;

  const ChatbotAddressLoaded(this.address);

  @override
  List<Object?> get props => [address];
}

class ChatbotError extends ChatbotState {
  final String message;

  const ChatbotError(this.message);

  @override
  List<Object?> get props => [message];
}
