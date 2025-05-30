import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:ulmo/core/helpers/api_keys.dart';
import 'package:ulmo/features/delivery/presentation/views/delivery_screen.dart'; // for callback signature

class AddressFormScreen extends StatefulWidget {
  final String? apiKey;
  final String? initialName;
  final String? initialPhone;
  final String? initialEmail;
  final String? initialCountry;
  final String? initialCity;
  final String? initialStreet;
  final void Function(
    String country,
    String city,
    String street,
    double lat,
    double lng,
  )?
  onSave;

  const AddressFormScreen({
    Key? key,
    this.apiKey,
    this.initialName,
    this.initialPhone,
    this.initialEmail,
    this.initialCountry,
    this.initialCity,
    this.initialStreet,
    this.onSave,
  }) : super(key: key);

  @override
  _AddressFormScreenState createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends State<AddressFormScreen> {
  final _streetController = TextEditingController();
  String? _country;
  String? _city;
  double? _pickedLat, _pickedLng;

  @override
  void initState() {
    super.initState();
    _country = widget.initialCountry;
    _city = widget.initialCity;
    if (widget.initialStreet != null) {
      _streetController.text = widget.initialStreet!;
    }
  }

  @override
  void dispose() {
    _streetController.dispose();
    super.dispose();
  }

  void _pickCountry() {
    // TODO: push a country picker
  }

  void _pickCity() {
    // TODO: push a city picker
  }

  void _onSave() {
    if (_streetController.text.isEmpty || _pickedLat == null) return;
    widget.onSave?.call(
      _country ?? "Jordan",
      _city ?? "Amman",
      _streetController.text,
      _pickedLat ?? 0.0,
      _pickedLng ?? 0.0,
    );
    // Pop the screen after saving
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Address', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'contact info',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildReadonlyField('Full name', widget.initialName ?? ''),
            const SizedBox(height: 8),
            _buildReadonlyField('Phone', widget.initialPhone ?? ''),
            const SizedBox(height: 8),
            _buildReadonlyField('Email', widget.initialEmail ?? ''),
            const SizedBox(height: 24),
            const Text(
              'address info',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ListTile(
              title: Text(_country!),
              subtitle: const Text('Delivery country'),
              trailing: const Icon(Icons.chevron_right),
              onTap: _pickCountry,
              tileColor: Colors.grey[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              title: Text(_city!),
              subtitle: const Text('Delivery city'),
              trailing: const Icon(Icons.chevron_right),
              onTap: _pickCity,
              tileColor: Colors.grey[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GooglePlaceAutoCompleteTextField(
                googleAPIKey: APIKeys.googleMapKey,
                inputDecoration: const InputDecoration(
                  hintText: 'Address',
                  border: InputBorder.none,
                ),
                debounceTime: 300,
                countries: const ['gb'],
                textEditingController: _streetController,
                getPlaceDetailWithLatLng: (prediction) {
                  _pickedLat = prediction.lat as double?;
                  _pickedLng = prediction.lng as double?;
                },
                itemClick: (prediction) async {
                  _streetController.text = prediction.description!;
                  // No need to fetch details separately, the lat/lng are already in the prediction
                  _pickedLat = (prediction?.lat ?? 77.78) as double?;
                  _pickedLng = (prediction?.lng ?? 77.90) as double?;
                  setState(() {});
                  FocusScope.of(context).unfocus();
                },
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onSave,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.black,
                  textStyle: const TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Save Address',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadonlyField(String label, String value) {
    return TextFormField(
      initialValue: value,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

Map<String, String> getGoogleApiHeaders() {
  return {
    'Authorization': 'Bearer YOUR_API_KEY',
    'Content-Type': 'application/json',
  };
}
