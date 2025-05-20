import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:ulmo/core/local/caches_keys.dart';
import 'package:ulmo/features/delivery/data/repo/delivery_repository.dart';
import 'package:ulmo/features/delivery/presentation/controller/delivery_event.dart';
import '../../data/model/delivery_model.dart';
import 'delivery_state.dart';

class DeliveryBloc extends Bloc<DeliveryEvent, DeliveryState> {
  final DeliveryRepository repository;
  DeliveryInfo? deliveryInfo;
  List<DeliveryInfo> _savedAddresses = [];

  DeliveryInfo? get currentDelivery => deliveryInfo;
  List<DeliveryInfo> get savedAddresses => _savedAddresses;

  DeliveryBloc({required DeliveryRepository D_repository})
    : repository = D_repository,
      super(DeliveryInitial()) {
    // Register events
    on<LoadSavedAddresses>(_onLoadSavedAddresses);
    on<SaveNewAddress>(_onSaveNewAddress);
    on<DeleteSavedAddress>(_onDeleteSavedAddress);
    on<SelectSavedAddress>(_onSelectSavedAddress);
    on<SetDeliveryAddress>(_onSetDeliveryAddress);
    on<SetDeliveryMethod>(_onSetDeliveryMethod);
    on<SetDeliverySchedule>(_onSetDeliverySchedule);
  }

  void _onSetDeliveryAddress(
    SetDeliveryAddress event,
    Emitter<DeliveryState> emit,
  ) {
    try {
      deliveryInfo = DeliveryInfo(
        userId: CacheKeys.cachedUserId,
        address: event.address,
        lat: event.lat,
        lng: event.lng,
        method: deliveryInfo?.method ?? '',
        date: deliveryInfo?.date ?? DateTime.now(),
        time: deliveryInfo?.time ?? TimeOfDay.now(),
      );

      emit(
        DeliverySelected(
          address: deliveryInfo!.address,
          lat: deliveryInfo!.lat,
          lng: deliveryInfo!.lng,
          method: deliveryInfo!.method,
          date: deliveryInfo!.date,
          time: deliveryInfo!.time,
        ),
      );
    } catch (e) {
      emit(DeliveryError('Failed to set address: ${e.toString()}'));
    }
  }

  void _onSetDeliveryMethod(
    SetDeliveryMethod event,
    Emitter<DeliveryState> emit,
  ) {
    try {
      if (deliveryInfo == null) {
        emit(DeliveryError('Please set delivery address first'));
        return;
      }

      deliveryInfo = DeliveryInfo(
        userId: deliveryInfo!.userId,
        address: deliveryInfo!.address,
        lat: deliveryInfo!.lat,
        lng: deliveryInfo!.lng,
        method: event.method,
        date: deliveryInfo!.date,
        time: deliveryInfo!.time,
      );

      emit(
        DeliverySelected(
          address: deliveryInfo!.address,
          lat: deliveryInfo!.lat,
          lng: deliveryInfo!.lng,
          method: deliveryInfo!.method,
          date: deliveryInfo!.date,
          time: deliveryInfo!.time,
        ),
      );
    } catch (e) {
      emit(DeliveryError('Failed to set delivery method: ${e.toString()}'));
    }
  }

  void _onSetDeliverySchedule(
    SetDeliverySchedule event,
    Emitter<DeliveryState> emit,
  ) {
    try {
      if (deliveryInfo == null) {
        emit(DeliveryError('Please set delivery address first'));
        return;
      }

      deliveryInfo = DeliveryInfo(
        userId: deliveryInfo!.userId,
        address: deliveryInfo!.address,
        lat: deliveryInfo!.lat,
        lng: deliveryInfo!.lng,
        method: deliveryInfo!.method,
        date: event.date ?? DateTime.now(),
        time: event.time ?? TimeOfDay.now(),
      );

      emit(
        DeliverySelected(
          address: deliveryInfo!.address,
          lat: deliveryInfo!.lat,
          lng: deliveryInfo!.lng,
          method: deliveryInfo!.method,
          date: deliveryInfo!.date,
          time: deliveryInfo!.time,
        ),
      );
    } catch (e) {
      emit(DeliveryError('Failed to set delivery schedule: ${e.toString()}'));
    }
  }

  Future<void> _onLoadSavedAddresses(
    LoadSavedAddresses event,
    Emitter<DeliveryState> emit,
  ) async {
    try {
      emit(DeliveryLoading());
      _savedAddresses = await repository.getSavedAddresses(event.userId);
      emit(SavedAddressesLoaded(_savedAddresses));
    } catch (e) {
      emit(DeliveryError('Failed to load saved addresses: ${e.toString()}'));
    }
  }

  Future<void> _onSaveNewAddress(
    SaveNewAddress event,
    Emitter<DeliveryState> emit,
  ) async {
    try {
      emit(DeliveryLoading());

      await repository.saveDeliveryInfo(
        DeliveryInfo(
          userId: event.userId,
          address: event.address,
          lat: event.lat,
          lng: event.lng,
          method: deliveryInfo?.method ?? '',
          date: deliveryInfo?.date ?? DateTime.now(),
          time: deliveryInfo?.time ?? TimeOfDay.now(),
        ),
      );

      _savedAddresses = await repository.getSavedAddresses(event.userId);
      emit(SavedAddressesLoaded(_savedAddresses));
    } catch (e) {
      emit(DeliveryError('Failed to save new address: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteSavedAddress(
    DeleteSavedAddress event,
    Emitter<DeliveryState> emit,
  ) async {
    try {
      emit(DeliveryLoading());
      await repository.deleteDeliveryInfo(event.addressId);
      _savedAddresses.removeWhere(
        (address) => address.address == event.addressId,
      );
      emit(SavedAddressesLoaded(_savedAddresses));
    } catch (e) {
      emit(DeliveryError('Failed to delete address: ${e.toString()}'));
    }
  }

  void _onSelectSavedAddress(
    SelectSavedAddress event,
    Emitter<DeliveryState> emit,
  ) {
    try {
      deliveryInfo = event.address;
      emit(
        DeliverySelected(
          address: deliveryInfo!.address,
          lat: deliveryInfo!.lat,
          lng: deliveryInfo!.lng,
          method: deliveryInfo!.method,
          date: deliveryInfo!.date,
          time: deliveryInfo!.time,
        ),
      );
    } catch (e) {
      emit(DeliveryError('Failed to select address: ${e.toString()}'));
    }
  }

  bool _isDeliveryInfoComplete() {
    if (deliveryInfo == null) return false;
    return deliveryInfo!.address.isNotEmpty && deliveryInfo!.method.isNotEmpty;
  }
}
