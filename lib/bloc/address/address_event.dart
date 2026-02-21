import 'package:equatable/equatable.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object?> get props => [];
}

class GetCurrentLocationEvent extends AddressEvent {}

class SearchAddressEvent extends AddressEvent {
  final String query;
  const SearchAddressEvent(this.query);

  @override
  List<Object?> get props => [query];
}
