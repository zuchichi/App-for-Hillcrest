import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../models/ride_request.dart';
import '../theme/app_theme.dart';
import '../services/ride_service.dart';
import '../services/auth_service.dart';
import '../services/broadcast_service.dart';

class RideDetailsPage extends StatefulWidget {
  const RideDetailsPage({super.key, required this.ride});

  final RideRequest ride;

  @override
  State<RideDetailsPage> createState() => _RideDetailsPageState();
}

class _RideDetailsPageState extends State<RideDetailsPage> {
  late ConfettiController _confettiController;
  bool _isAccepting = false;
  bool _locallyAccepted = false; // Prevents double acceptance
  final RideService _rideService = RideService();
  final AuthService _authService = AuthService();
  final BroadcastService _broadcastService = BroadcastService();

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _handleAccept() async {
    setState(() => _isAccepting = true);

    final userModel = await _authService.userModelStream.first;
    final driverName = userModel?.fullName ?? 'Hillcrest Driver';
    const driverPhone = '816-555-0199';

    await _rideService.acceptRide(widget.ride.id, driverName, driverPhone);

    if (widget.ride.requesterUid != null) {
      await _broadcastService.sendBroadcast(
        title: 'Ride Accepted!',
        message: 'Your ride request for ${widget.ride.dateLabel} has been accepted by $driverName.',
        senderUid: _authService.currentUser?.uid ?? '',
        targetUid: widget.ride.requesterUid, // Targeting the person who requested it
      );
    }

    setState(() {
      _isAccepting = false;
      _locallyAccepted = true; // Update UI to hide button
    });
    
    _confettiController.play();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Congratulations, you just accepted a ride!'),
          backgroundColor: AppTheme.primaryGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ride = widget.ride;
    // Hide the button if the ride is already assigned OR if it was just accepted locally
    final bool isPending = ride.status == RideStatus.unassigned && !_locallyAccepted;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Ride Details',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoSection('Participant', ride.participantName, Icons.person_rounded),
                        const SizedBox(height: 16),
                        _buildInfoSection('Contact Info', ride.phone, Icons.phone_rounded),
                        const SizedBox(height: 16),
                        _buildInfoSection('Date & Time', '${ride.dateLabel}\nPickup: ${ride.pickupTime}', Icons.calendar_today_rounded),
                        const SizedBox(height: 16),
                        _buildInfoSection('Route', 'From: ${ride.fromAddress}\nTo: ${ride.toAddress}', Icons.map_rounded),
                        const SizedBox(height: 16),
                        _buildInfoSection('Reason', ride.reason, Icons.help_outline_rounded),
                        const SizedBox(height: 16),
                        _buildInfoSection(
                          'Status',
                          (_locallyAccepted || ride.status == RideStatus.assigned) ? 'Assigned' : 'Pending',
                          (_locallyAccepted || ride.status == RideStatus.assigned) ? Icons.check_circle_rounded : Icons.warning_amber_rounded,
                          color: (_locallyAccepted || ride.status == RideStatus.assigned) ? AppTheme.primaryGreen : Colors.orange,
                        ),
                        if (_locallyAccepted || ride.status == RideStatus.assigned) ...[
                          const SizedBox(height: 16),
                          _buildInfoSection('Driver', ride.driverName ?? 'You', Icons.drive_eta_rounded),
                        ],
                        const SizedBox(height: 40),
                        if (isPending)
                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton(
                              onPressed: _isAccepting ? null : _handleAccept,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryGreen,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                elevation: 0,
                              ),
                              child: _isAccepting 
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text('Accept This Ride', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [AppTheme.primaryGreen, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String label, String value, IconData icon, {Color? color}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (color ?? AppTheme.primaryGreen).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color ?? AppTheme.primaryGreen, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.black38, letterSpacing: 1.1)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
