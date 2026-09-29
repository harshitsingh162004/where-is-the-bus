import 'dart:math';
import 'package:flutter/material.dart';

import '../models/bus.dart';
import '../services/bus_service.dart';
import '../data/bus_routes.dart';
import '../data/bus_stops.dart';
import 'map_screen.dart';

class BusListScreen extends StatefulWidget {
  final String startLocation;
  final String endLocation;

  const BusListScreen({
    super.key,
    required this.startLocation,
    required this.endLocation,
  });

  @override
  State<BusListScreen> createState() => _BusListScreenState();
}

class _BusListScreenState extends State<BusListScreen> {
  bool _isLoading = true;
  List<Bus> _availableBuses = [];

  @override
  void initState() {
    super.initState();
    _loadBuses();
  }

  /// Haversine distance (km)
  double _distance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371;
    final dLat = (lat2 - lat1) * pi / 180;
    final dLon = (lon2 - lon1) * pi / 180;
    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) *
            cos(lat2 * pi / 180) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  Future<void> _loadBuses() async {
    await Future.delayed(const Duration(seconds: 1));

    // Find user "From" stop
    final fromStop = busStops.firstWhere((s) => s.name == widget.startLocation);

    // Filter routes that serve From → To
    final validRoutes = busRoutes.where(
      (route) => route.serves(widget.startLocation, widget.endLocation),
    );

    final List<Bus> buses = [];

    for (final route in validRoutes) {
      // Create 1–2 buses per route (demo purpose)
      for (int i = 0; i < 2; i++) {
        final liveBus = await BusService().getLiveLocation();

        final distanceToFrom = _distance(
          liveBus.latitude,
          liveBus.longitude,
          fromStop.latitude,
          fromStop.longitude,
        );

        final etaMinutes = (distanceToFrom / 30 * 60).round();

        buses.add(
          liveBus.copyWith(
            id: '${route.routeId}_bus_$i',
            routeId: route.routeId,
            busNumber: 'BUS-${route.routeId}-$i',
            estimatedArrival: DateTime.now().add(Duration(minutes: etaMinutes)),
          ),
        );
      }
    }

    setState(() {
      _availableBuses = buses;
      _isLoading = false;
    });
  }

  void _trackBus(Bus bus) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => MapScreen(
              bus: bus,
              fromStopName: widget.startLocation,
              toStopName: widget.endLocation,
            ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'on_route':
        return Colors.green;
      case 'delayed':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.startLocation} → ${widget.endLocation}'),
        centerTitle: true,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _availableBuses.isEmpty
              ? const Center(child: Text('No buses available'))
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _availableBuses.length,
                itemBuilder: (context, index) {
                  final bus = _availableBuses[index];
                  final minutesAway =
                      bus.estimatedArrival.difference(DateTime.now()).inMinutes;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      leading: Icon(
                        Icons.directions_bus,
                        color: _statusColor(bus.status),
                      ),
                      title: Text('Bus ${bus.busNumber}'),
                      subtitle: Text(
                        'ETA to ${widget.startLocation}: $minutesAway min',
                      ),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () => _trackBus(bus),
                    ),
                  );
                },
              ),
    );
  }
}
