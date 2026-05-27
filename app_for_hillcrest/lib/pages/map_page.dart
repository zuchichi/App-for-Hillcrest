import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/ride_request.dart';

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

    return Column(
      children: [
        Expanded(
          flex: 6,
          child: GoogleMap(
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
                ? const Center(
                    child: Text(
                      'Tap a pin to view ride details.',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : Column(
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
                      _detailRow(Icons.arrow_forward, selectedRide!.fromAddress),
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
      ],
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
