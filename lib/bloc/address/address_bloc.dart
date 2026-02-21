import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'address_event.dart';
import 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  AddressBloc() : super(AddressInitial()) {
    on<GetCurrentLocationEvent>(_onGetCurrentLocation);
    on<SearchAddressEvent>(_onSearchAddress);
  }

  Future<void> _onGetCurrentLocation(GetCurrentLocationEvent event, Emitter<AddressState> emit) async {
    emit(AddressLoading());
    try {
      final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      String address = placemarks.isNotEmpty
          ? '${placemarks.first.street ?? ''}, ${placemarks.first.subLocality ?? ''}, ${placemarks.first.locality ?? ''}, ${placemarks.first.country ?? ''}'
          : 'Không tìm thấy địa chỉ';
      emit(AddressLoaded(address, LatLng(position.latitude, position.longitude)));
    } catch (e) {
      emit(AddressError('Lỗi định vị: $e'));
    }
  }

  Future<void> _onSearchAddress(SearchAddressEvent event, Emitter<AddressState> emit) async {
    emit(AddressLoading());
    try {
      List<Location> locations = await locationFromAddress(event.query);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        List<Placemark> placemarks = await placemarkFromCoordinates(loc.latitude, loc.longitude);
        String address = placemarks.isNotEmpty
            ? '${placemarks.first.street ?? ''}, ${placemarks.first.subLocality ?? ''}, ${placemarks.first.locality ?? ''}, ${placemarks.first.country ?? ''}'
            : 'Không tìm thấy địa chỉ';
        emit(AddressLoaded(address, LatLng(loc.latitude, loc.longitude)));
      } else {
        emit(AddressError('Không tìm thấy địa chỉ'));
      }
    } catch (e) {
      emit(AddressError('Lỗi tìm kiếm: $e'));
    }
  }
}
