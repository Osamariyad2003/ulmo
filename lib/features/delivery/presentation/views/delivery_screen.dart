import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controller/delivery_bloc.dart';
import '../controller/delivery_event.dart';

class AddressPickerButton extends StatelessWidget {
  final LatLng initialPosition;
  final String apiKey;

  const AddressPickerButton({
    super.key,
    required this.initialPosition,
    required this.apiKey,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text("Pick Address on Map"),
      onPressed: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlacePicker(
              apiKey: apiKey,
              initialPosition: initialPosition,
              useCurrentLocation: true,
              onPlacePicked: (result) {
                context.read<DeliveryBloc>().add(SetDeliveryAddress(
                  result.formattedAddress ?? "",
                  result.geometry!.location.lat,
                  result.geometry!.location.lng,
                ));
                Navigator.of(context).pop();
              },
            ),
          ),
        );
      },
    );
  }
}
