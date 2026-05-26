import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const HillcrestRidesApp());
}

class HillcrestRidesApp extends StatelessWidget {
  const HillcrestRidesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hillcrest Rides',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFF3F4F6),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3C8D4C),
          primary: const Color(0xFF3C8D4C),
        ),
        useMaterial3: true,
      ),
      home: const IntroPage(),
    );
  }
}

enum RideStatus { assigned, unassigned }

class RideRequest {
  RideRequest({
    required this.id,
    required this.participantName,
    required this.dateLabel,
    required this.pickupTime,
    required this.dropoffTime,
    required this.fromAddress,
    required this.toAddress,
    required this.phone,
    required this.reason,
    required this.driverName,
    required this.driverPhone,
    required this.departureLocation,
    required this.arrivalLocation,
    required this.status,
  });

  final String id;
  final String participantName;
  final String dateLabel;
  final String pickupTime;
  final String dropoffTime;
  final String fromAddress;
  final String toAddress;
  final String phone;
  final String reason;
  final String driverName;
  final String driverPhone;
  final LatLng departureLocation;
  final LatLng arrivalLocation;
  final RideStatus status;
}

final List<RideRequest> sampleRides = [
  RideRequest(
    id: '1',
    participantName: 'John Doe',
    dateLabel: '6/20/2026',
    pickupTime: '8:15 AM CST',
    dropoffTime: '1:15 PM CST',
    fromAddress: '14128 S 16th St',
    toAddress: '1305 Branch St',
    phone: '816-412-8812',
    reason: 'Car broke down',
    driverName: 'Ms. Tupi',
    driverPhone: '832-128-4415',
    departureLocation: const LatLng(39.0301, -94.5805),
    arrivalLocation: const LatLng(39.0382, -94.5732),
    status: RideStatus.assigned,
  ),
  RideRequest(
    id: '2',
    participantName: 'Stacy Adams',
    dateLabel: '6/21/2026',
    pickupTime: '7:20 AM CST',
    dropoffTime: '3:15 PM CST',
    fromAddress: '816 Main St',
    toAddress: '2322 Blue Pkwy',
    phone: '816-555-1200',
    reason: 'Work',
    driverName: 'Unassigned',
    driverPhone: 'N/A',
    departureLocation: const LatLng(39.0510, -94.5870),
    arrivalLocation: const LatLng(39.0805, -94.5310),
    status: RideStatus.unassigned,
  ),
  RideRequest(
    id: '3',
    participantName: 'Jack Indiana',
    dateLabel: '6/22/2026',
    pickupTime: '10:10 AM CST',
    dropoffTime: '12:00 PM CST',
    fromAddress: '320 Oak Ave',
    toAddress: '1000 Medical Dr',
    phone: '816-555-3003',
    reason: 'Medical appt',
    driverName: 'Mr. Brewer',
    driverPhone: '816-555-1010',
    departureLocation: const LatLng(39.0922, -94.6001),
    arrivalLocation: const LatLng(39.1010, -94.5620),
    status: RideStatus.assigned,
  ),
  RideRequest(
    id: '4',
    participantName: 'Timmy Wood',
    dateLabel: '6/23/2026',
    pickupTime: '11:00 AM CST',
    dropoffTime: '2:00 PM CST',
    fromAddress: '88 Walnut St',
    toAddress: '1907 School Rd',
    phone: '816-555-8833',
    reason: 'School',
    driverName: 'Unassigned',
    driverPhone: 'N/A',
    departureLocation: const LatLng(39.0460, -94.6301),
    arrivalLocation: const LatLng(39.0700, -94.6201),
    status: RideStatus.unassigned,
  ),
  RideRequest(
    id: '5',
    participantName: 'Forest Nelson',
    dateLabel: '6/24/2026',
    pickupTime: '8:00 AM CST',
    dropoffTime: '11:45 AM CST',
    fromAddress: '44 South St',
    toAddress: '55 Dental Pkwy',
    phone: '816-555-0190',
    reason: 'Dental appt',
    driverName: 'Ms. Lani',
    driverPhone: '816-555-6700',
    departureLocation: const LatLng(39.0838, -94.6521),
    arrivalLocation: const LatLng(39.0710, -94.6400),
    status: RideStatus.assigned,
  ),
];

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.directions_car_filled_rounded,
                  size: 96,
                  color: Color(0xFF3C8D4C),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Hillcrest Ride Request',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => const LoginSignupPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3C8D4C),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: const Text('Get Started'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginSignupPage extends StatefulWidget {
  const LoginSignupPage({super.key});

  @override
  State<LoginSignupPage> createState() => _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  bool isSignUp = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login / Signup')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 30),
            TextField(
              decoration: _fieldDecoration('Username', Icons.person_outline),
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: _fieldDecoration('Password', Icons.lock_outline),
            ),
            const SizedBox(height: 16),
            if (isSignUp)
              TextField(
                obscureText: true,
                decoration: _fieldDecoration(
                  'Confirm Password',
                  Icons.lock_reset_outlined,
                ),
              ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => const DashboardShell(),
                    ),
                    (_) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3C8D4C),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(isSignUp ? 'Create Account' : 'Login'),
              ),
            ),
            TextButton(
              onPressed: () => setState(() => isSignUp = !isSignUp),
              child: Text(
                isSignUp
                    ? 'Already have an account? Login'
                    : 'Need an account? Sign up',
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Firebase Auth-ready layout (username/password).',
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
    );
  }
}

class DashboardShell extends StatefulWidget {
  const DashboardShell({super.key});

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> {
  int currentTab = 1;
  String searchTerm = '';

  List<RideRequest> get _filtered {
    if (searchTerm.trim().isEmpty) {
      return sampleRides;
    }
    final q = searchTerm.toLowerCase();
    return sampleRides
        .where(
          (ride) =>
              ride.participantName.toLowerCase().contains(q) ||
              ride.dateLabel.toLowerCase().contains(q),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            _TopHeader(
              onSearchChanged: (value) => setState(() => searchTerm = value),
              hint: currentTab == 0
                  ? 'Search names / rides on map'
                  : 'Search names / dates',
            ),
            Expanded(
              child: IndexedStack(
                index: currentTab,
                children: [
                  MapPage(rides: _filtered),
                  HomePage(rides: _filtered),
                  CalendarPage(rides: _filtered),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFFF3F4F6),
        elevation: 0,
        child: SizedBox(
          height: 90,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () => setState(() => currentTab = 0),
                    icon: Icon(
                      Icons.place_outlined,
                      size: 30,
                      color:
                          currentTab == 0 ? const Color(0xFF3C8D4C) : Colors.black87,
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() => currentTab = 1),
                    icon: Icon(
                      Icons.home_outlined,
                      size: 30,
                      color:
                          currentTab == 1 ? const Color(0xFF3C8D4C) : Colors.black87,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => const RequestManageRidePage(),
                      ),
                    ),
                    icon: const Icon(Icons.add_circle_outline, size: 30),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              const Opacity(
                opacity: .75,
                child: Text(
                  'HILLCREST THRIFT COUNTY',
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 1.1,
                    color: Color(0xFF88A888),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopHeader extends StatelessWidget {
  const _TopHeader({required this.onSearchChanged, required this.hint});

  final ValueChanged<String> onSearchChanged;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
      child: Row(
        children: [
          Builder(
            builder: (context) => IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: const Icon(Icons.menu),
            ),
          ),
          Expanded(
            child: TextField(
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: hint,
                filled: true,
                fillColor: const Color(0xFFEAE7F2),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.search),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.rides});

  final List<RideRequest> rides;

  @override
  Widget build(BuildContext context) {
    final byName = <String, List<RideRequest>>{};
    for (final ride in rides) {
      byName.putIfAbsent(ride.participantName, () => []).add(ride);
    }
    final names = byName.keys.toList()..sort();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              'Current Rides',
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 8),
          const Center(child: Icon(Icons.directions_car, size: 46)),
          const SizedBox(height: 14),
          const Divider(color: Color(0xFF3C8D4C), thickness: 1.5),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              itemCount: names.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (_, index) {
                final name = names[index];
                final rideList = byName[name]!;
                return ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  childrenPadding: const EdgeInsets.only(bottom: 8),
                  title: Text(
                    '$name  -  ${rideList.length} Rides',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  children: [
                    ...rideList.map(
                      (ride) => ListTile(
                        title: Text('${ride.dateLabel} - ${ride.pickupTime}'),
                        subtitle: Text('${ride.fromAddress} -> ${ride.toAddress}'),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key, required this.rides});

  final List<RideRequest> rides;

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  String selectedMonth = 'Mon';
  String selectedYear = '2026';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              'Weekly Rides',
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _picker(
                value: selectedMonth,
                items: const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                onChanged: (value) => setState(() => selectedMonth = value),
              ),
              const SizedBox(width: 10),
              _picker(
                value: selectedYear,
                items: const ['2025', '2026', '2027'],
                onChanged: (value) => setState(() => selectedYear = value),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(color: Color(0xFF3C8D4C), thickness: 1.5),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: widget.rides.length,
              itemBuilder: (_, index) {
                final ride = widget.rides[index];
                return ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          ride.participantName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 21,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      Icon(
                        ride.status == RideStatus.assigned
                            ? Icons.check_circle
                            : Icons.warning_amber_rounded,
                        color: ride.status == RideStatus.assigned
                            ? Colors.green
                            : Colors.orange,
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text('${ride.pickupTime}\n${ride.dropoffTime}'),
                  ),
                  children: [
                    ListTile(
                      title: Text('Date: ${ride.dateLabel}'),
                      subtitle: Text(
                        'Driver: ${ride.driverName}\n'
                        'From: ${ride.fromAddress}\n'
                        'To: ${ride.toAddress}\n'
                        'Reason: ${ride.reason}',
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _picker({
    required String value,
    required List<String> items,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: DropdownButton<String>(
        value: value,
        underline: const SizedBox.shrink(),
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: (value) {
          if (value != null) {
            onChanged(value);
          }
        },
      ),
    );
  }
}

class RequestManageRidePage extends StatefulWidget {
  const RequestManageRidePage({super.key});

  @override
  State<RequestManageRidePage> createState() => _RequestManageRidePageState();
}

class _RequestManageRidePageState extends State<RequestManageRidePage> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  String reason = 'work';
  String pickupBy = 'Ms. Tupi - 832-128-4415';

  @override
  void dispose() {
    _dateController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const BackButton(), title: const Text('Request Ride')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Divider(color: Color(0xFF3C8D4C), thickness: 1.5),
              const SizedBox(height: 12),
              _lineField('Date of ride M/D/Y', _dateController),
              _lineField('Your Full Name', _nameController),
              _lineField('Phone Number', _phoneController),
              _lineField('Departure Address', _fromController),
              _lineField('Arrival Address', _toController),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: reason,
                decoration: const InputDecoration(labelText: 'Reason For Ride'),
                items: const [
                  DropdownMenuItem(value: 'work', child: Text('Work')),
                  DropdownMenuItem(value: 'medical appt', child: Text('Medical appt')),
                  DropdownMenuItem(value: 'dental appt', child: Text('Dental appt')),
                  DropdownMenuItem(value: 'school', child: Text('School')),
                  DropdownMenuItem(value: 'other', child: Text('Other')),
                ],
                onChanged: (value) => setState(() => reason = value ?? reason),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: pickupBy,
                decoration: const InputDecoration(labelText: 'Pick Up By'),
                items: const [
                  DropdownMenuItem(
                    value: 'Ms. Tupi - 832-128-4415',
                    child: Text('Ms. Tupi - 832-128-4415'),
                  ),
                  DropdownMenuItem(
                    value: 'Mr. Brewer - 816-555-1010',
                    child: Text('Mr. Brewer - 816-555-1010'),
                  ),
                  DropdownMenuItem(
                    value: 'Ms. Lani - 816-555-6700',
                    child: Text('Ms. Lani - 816-555-6700'),
                  ),
                ],
                onChanged: (value) => setState(() => pickupBy = value ?? pickupBy),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Ride request submitted successfully.'),
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3C8D4C),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Request Ride'),
                  ),
                  const SizedBox(width: 14),
                  IconButton(
                    onPressed: () {
                      _formKey.currentState?.reset();
                      _dateController.clear();
                      _nameController.clear();
                      _phoneController.clear();
                      _fromController.clear();
                      _toController.clear();
                    },
                    icon: const Icon(Icons.delete_outline, size: 32),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _lineField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Required';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black54),
          ),
        ),
      ),
    );
  }
}

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

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.person_outline),
            title: Text('Account Details'),
            subtitle: Text('Change your name and profile details'),
          ),
          ListTile(
            leading: Icon(Icons.lock_outline),
            title: Text('Change Password'),
            subtitle: Text('Update account password securely'),
          ),
          ListTile(
            leading: Icon(Icons.notifications_outlined),
            title: Text('Notifications'),
            subtitle: Text('Choose how ride updates are delivered'),
          ),
          ListTile(
            leading: Icon(Icons.delete_outline, color: Colors.red),
            title: Text('Delete Account', style: TextStyle(color: Colors.red)),
            subtitle: Text('Permanently delete this account'),
          ),
        ],
      ),
    );
  }
}

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final _messageController = TextEditingController();
  String selectedAttachment = 'No file attached';

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendSupportEmail() async {
    final body = Uri.encodeComponent(_messageController.text.trim());
    final uri = Uri.parse('mailto:support@hillcrest.org?subject=Ride App Help&body=$body');
    if (!await launchUrl(uri)) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open email app.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Need help with rides? Send support details below.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _messageController,
              maxLines: 6,
              decoration: InputDecoration(
                labelText: 'Support message',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      selectedAttachment = 'Attachment selected (demo placeholder)';
                    });
                  },
                  icon: const Icon(Icons.attach_file),
                  label: const Text('Attach file'),
                ),
                const SizedBox(width: 10),
                Expanded(child: Text(selectedAttachment)),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _sendSupportEmail,
                icon: const Icon(Icons.send),
                label: const Text('Send to support email'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF3C8D4C)),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'Hillcrest Rides',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month_outlined),
            title: const Text('Request / Manage Ride'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const RequestManageRidePage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute<void>(builder: (_) => const SettingsPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute<void>(builder: (_) => const HelpPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
