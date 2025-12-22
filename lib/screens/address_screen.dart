import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../data/address_data.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final MapController _mapController = MapController();

  LatLng? centerLocation;
  bool isInitLoading = true;
  bool isResetLoading = false;
  bool isFetchingAddress = false;

  final nameCtrl = TextEditingController();
  final countryCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final addressCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAddress();
  }

  // ================= LOAD =================

  Future<void> _loadAddress() async {
    final data = await AddressData.load();

    if (data != null) {
      nameCtrl.text = data['name'] ?? '';
      countryCtrl.text = data['country'] ?? '';
      cityCtrl.text = data['city'] ?? '';
      phoneCtrl.text = data['phone'] ?? '';
      addressCtrl.text = data['address'] ?? '';

      if (data['lat'] != null && data['lng'] != null) {
        centerLocation = LatLng(data['lat'], data['lng']);
      }
    } else {
      await _getDeviceLocation();
      await _reverseGeocode();
    }

    setState(() => isInitLoading = false);
  }

  Future<void> _getDeviceLocation() async {
    await Geolocator.requestPermission();
    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    centerLocation = LatLng(pos.latitude, pos.longitude);
  }

  // ================= RESET =================

  Future<void> _resetToCurrentLocation() async {
    setState(() => isResetLoading = true);

    await _getDeviceLocation();

    if (centerLocation != null) {
      _mapController.move(centerLocation!, 15);
      await _reverseGeocode();
    }

    setState(() => isResetLoading = false);
  }

  // ================= REVERSE GEOCODING =================

  Future<void> _reverseGeocode() async {
    if (centerLocation == null || isFetchingAddress) return;

    isFetchingAddress = true;

    try {
      final placemarks = await placemarkFromCoordinates(
        centerLocation!.latitude,
        centerLocation!.longitude,
      );

      if (placemarks.isNotEmpty) {
        final p = placemarks.first;

        addressCtrl.text = '${p.street ?? ''}, ${p.subLocality ?? ''}'.trim();
        cityCtrl.text = p.locality ?? '';
        countryCtrl.text = p.country ?? '';
      }
    } catch (_) {}

    isFetchingAddress = false;
  }

  // ================= MAP MOVE =================

  void _onMapMoved(MapPosition position, bool hasGesture) {
    if (position.center != null && hasGesture) {
      centerLocation = position.center!;
      _reverseGeocode();
      setState(() {});
    }
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _appBar(),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _field('Name', nameCtrl),
                  _doubleField('Country', countryCtrl, 'City', cityCtrl),
                  _field('Phone Number', phoneCtrl),
                  _field('Address Detail', addressCtrl, maxLines: 2),

                  const SizedBox(height: 16),

                  // ===== MAP =====
                  Container(
                    height: 260,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: isInitLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Stack(
                            children: [
                              FlutterMap(
                                mapController: _mapController,
                                options: MapOptions(
                                  center: centerLocation!,
                                  zoom: 15,
                                  onPositionChanged: _onMapMoved,
                                ),
                                children: [
                                  TileLayer(
                                    urlTemplate:
                                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  ),
                                ],
                              ),

                              // 📍 PIN
                              const Center(
                                child: Icon(
                                  Icons.location_pin,
                                  size: 48,
                                  color: Colors.red,
                                ),
                              ),

                              // 🔄 RESET BUTTON
                              Positioned(
                                bottom: 12,
                                right: 12,
                                child: GestureDetector(
                                  onTap: isResetLoading
                                      ? null
                                      : _resetToCurrentLocation,
                                  child: Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: isResetLoading
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Color(0xFFD4AF37),
                                              ),
                                            )
                                          : const Icon(
                                              Icons.my_location,
                                              color: Color(0xFFD4AF37),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),

                  const SizedBox(height: 8),

                  if (centerLocation != null)
                    Text(
                      'Lat: ${centerLocation!.latitude.toStringAsFixed(5)}, '
                      'Lng: ${centerLocation!.longitude.toStringAsFixed(5)}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                ],
              ),
            ),

            _saveButton(),
          ],
        ),
      ),
    );
  }

  // ================= COMPONENTS =================

  Widget _appBar() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const CircleAvatar(
              backgroundColor: Color(0xFFF5F5F5),
              child: Icon(Icons.arrow_back),
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'Address',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl,
          maxLines: maxLines,
          decoration: _decoration(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _doubleField(
    String l1,
    TextEditingController c1,
    String l2,
    TextEditingController c2,
  ) {
    return Row(
      children: [
        Expanded(child: _field(l1, c1)),
        const SizedBox(width: 12),
        Expanded(child: _field(l2, c2)),
      ],
    );
  }

  InputDecoration _decoration() {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _saveButton() {
    return GestureDetector(
      onTap: () async {
        await AddressData.save({
          'name': nameCtrl.text,
          'country': countryCtrl.text,
          'city': cityCtrl.text,
          'phone': phoneCtrl.text,
          'address': addressCtrl.text,
          'lat': centerLocation?.latitude,
          'lng': centerLocation?.longitude,
        });
        Navigator.pop(context);
      },
      child: Container(
        height: 64,
        width: double.infinity,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Center(
          child: Text(
            'Save Address',
            style: TextStyle(
              color: Color(0xFFD4AF37),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
