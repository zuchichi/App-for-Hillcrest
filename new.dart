import 'dart:io' show Platform; // Add this import
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/ride_request.dart';
import '../data/translations.dart';
import '../theme/app_theme.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key, required this.rides});

  final List<RideRequest> rides;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  RideRequest? selectedRide;
  GoogleMapController? mapController;

  @override
  Widget build(BuildContext context) {
    // Check if we are on an unsupported platform (Linux/Windows/macOS)
    final bool isDesktop = !kIsWeb &&
        (Platform.isLinux || Platform.isWindows || Platform.isMacOS);

    final pins = <Marker>{};
    for (final ride in widget.rides) {
      pins.add(
        Marker(
          markerId: MarkerId('${ride.id}_from'),
          position: ride.departureLocation,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: InfoWindow(title: '${ride.participantName} - Departure'),
          onTap: () => setState(() => selectedRide = ride),
        ),
      );
      pins.add(
        Marker(
          markerId: MarkerId('${ride.id}_to'),
          position: ride.arrivalLocation,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(title: '${ride.participantName} - Arrival'),
          onTap: () => setState(() => selectedRide = ride),
        ),
      );
    }

    return ValueListenableBuilder(
      valueListenable: TranslationService.currentLanguage,
      builder: (context, lang, _) {
        return Column(
          children: [
            Expanded(
              flex: 6,
              child: isDesktop
                  ? _buildDesktopPlaceholder() // Show this on Linux
                  : GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(39.0458, -94.5966),
                  zoom: 11.5,
                ),
                markers: pins,
                onMapCreated: (controller) => mapController = controller,
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                color: Colors.white,
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: selectedRide == null
                    ? Center(
                  child: Text(
                    TranslationService.translate('map_tap_pin'),
                    style: const TextStyle(fontSize: 16),
                  ),
                )
                    : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedRide!.participantName,
                        style: const TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _detailRow(Icons.calendar_month, selectedRide!.dateLabel),
                      _detailRow(Icons.call_outlined, selectedRide!.phone),
                      _detailRow(
                          Icons.arrow_forward, selectedRide!.fromAddress),
                      _detailRow(Icons.arrow_back, selectedRide!.toAddress),
                      _detailRow(Icons.access_time, selectedRide!.pickupTime),
                      _detailRow(Icons.help_outline, selectedRide!.reason),
                      _detailRow(
                        Icons.person_outline,
                        '${selectedRide!.driverName} will pick you up',
                      ),
                      _detailRow(Icons.phone, selectedRide!.driverPhone),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDesktopPlaceholder() {
    return Container(
      color: const Color(0xFFE5E7EB),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.map_outlined, size: 64, color: Colors.black26),
            const SizedBox(height: 16),
            const Text(
              'Map Preview',
              style: TextStyle(fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black45),
            ),
            const SizedBox(height: 8),
            Text(
              'Google Maps is not supported on Linux.\nRun on Android, iOS, or Web to see the live map.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black38),
            ),
            const SizedBox(height: 24),
            // Still allow interaction with the rides list for testing
            Wrap(
              spacing: 10,
              children: widget.rides.take(3).map((ride) =>
                  ActionChip(
                    label: Text(ride.participantName),
                    onPressed: () => setState(() => selectedRide = ride),
                  )).toList(),
            )
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Icon(icon, size: 19),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 18))),
        ],
      ),
    );
  }
}