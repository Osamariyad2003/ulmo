import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/delivery_model.dart';
import 'delivery_event.dart';
import 'delivery_state.dart';

class DeliveryBloc extends Bloc<DeliveryEvent, DeliveryState> {
  DeliveryBloc() : super(DeliveryState()) {
    on<SetDeliveryAddress>((event, emit) {
      emit(
        state.copyWith(
          address: event.address,
          lat: event.lat,
          lng: event.lng,
          saved: false,
          error: null,
        ),
      );
    });

    on<SetDeliveryMethod>((event, emit) {
      emit(state.copyWith(method: event.method));
    });

    on<SetDeliverySchedule>((event, emit) {
      // Only update the fields that are provided
      final updatedDate = event.date ?? state.date;
      final updatedTime = event.time ?? state.time;

      emit(state.copyWith(date: updatedDate, time: updatedTime));
    });

    on<SaveDeliveryToFirebase>((event, emit) async {
      try {
        if (state.address == null ||
            state.lat == null ||
            state.lng == null ||
            state.method == null ||
            state.date == null ||
            state.time == null) {
          throw Exception("Incomplete delivery info");
        }

        final delivery = DeliveryInfo(
          address: state.address!,
          lat: state.lat!,
          lng: state.lng!,
          method: state.method!,
          date: state.date!,
          time: state.time!,
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(event.userId)
            .collection('places')
            .add(delivery.toMap());

        emit(state.copyWith(saved: true));
      } catch (e) {
        emit(state.copyWith(error: e.toString()));
      }
    });
  }
}
