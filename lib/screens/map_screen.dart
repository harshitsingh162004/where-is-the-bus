import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../models/bus.dart';
import '../services/bus_service.dart';
import '../data/bus_stops.dart';

class MapScreen extends StatefulWidget {
  final Bus bus;
  final String fromStopName;
  final String toStopName;

  const MapScreen({
    super.key,
    required this.bus,
    required this.fromStopName,
    required this.toStopName,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();

  Bus? _currentBus;

  // 🟢 Bus → From
  List<LatLng> _busToFromRoute = [];

  // 🔵 From → To
  List<LatLng> _fromToRoute = [];

  LatLng? _busPosition;
  bool _tracking = true;

  final double _zoom = 15;

  @override
  void initState() {
    super.initState();
    _currentBus = widget.bus;
    _busPosition = LatLng(widget.bus.latitude, widget.bus.longitude);

    _loadRoutes();
    _startTracking();
  }

  @override
  void dispose() {
    _tracking = false;
    super.dispose();
  }

  // ---------------- ROUTES ----------------

  Future<void> _loadRoutes() async {
    final fromStop = busStops.firstWhere((s) => s.name == widget.fromStopName);
    final toStop = busStops.firstWhere((s) => s.name == widget.toStopName);

    // 🟢 Bus → From
    _busToFromRoute = await _fetchRoute(
      _busPosition!.latitude,
      _busPosition!.longitude,
      fromStop.latitude,
      fromStop.longitude,
    );

    // 🔵 From → To
    _fromToRoute = await _fetchRoute(
      fromStop.latitude,
      fromStop.longitude,
      toStop.latitude,
      toStop.longitude,
    );

    setState(() {});
  }

  Future<List<LatLng>> _fetchRoute(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) async {
    const apiKey = 'a9c75da1-ca99-4e26-96e8-f33881730191';

    final url =
        'https://graphhopper.com/api/1/route'
        '?point=$startLat,$startLng'
        '&point=$endLat,$endLng'
        '&vehicle=car'
        '&points_encoded=false'
        '&locale=en'
        '&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception('GraphHopper API error');
    }

    final data = jsonDecode(response.body);

    if (data['paths'] == null || data['paths'].isEmpty) {
      throw Exception('No route found');
    }

    final List coordinates = data['paths'][0]['points']['coordinates'];

    return coordinates.map<LatLng>((c) => LatLng(c[1], c[0])).toList();
  }

  // ---------------- NEAREST POINT ON ROUTE ----------------

  LatLng _nearestPointOnRoute(LatLng current, List<LatLng> route) {
    LatLng nearest = route.first;
    double minDistance = double.infinity;

    for (final point in route) {
      final d = const Distance().as(LengthUnit.Meter, current, point);
      if (d < minDistance) {
        minDistance = d;
        nearest = point;
      }
    }
    return nearest;
  }

  // ---------------- LIVE TRACKING ----------------

  void _startTracking() async {
    while (_tracking && mounted) {
      final updatedBus = await BusService().getLiveLocation();

      final livePosition = LatLng(updatedBus.latitude, updatedBus.longitude);

      LatLng newPosition = livePosition;

      // Snap bus to green route (realistic road alignment)
      if (_busToFromRoute.isNotEmpty) {
        newPosition = _nearestPointOnRoute(livePosition, _busToFromRoute);
      }

      setState(() {
        _currentBus = updatedBus;
        _busPosition = newPosition;
      });

      _mapController.move(_busPosition!, _zoom);
      await Future.delayed(const Duration(seconds: 6));
    }
  }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bus → ${widget.fromStopName} → ${widget.toStopName}'),
        centerTitle: true,
      ),
      body:
          _busPosition == null
              ? const Center(child: CircularProgressIndicator())
              : FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _busPosition!,
                  initialZoom: _zoom,
                  maxZoom: 18,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.where_is_the_bus',
                  ),

                  // 🟢 GREEN: Bus → From
                  PolylineLayer(
                    polylines: [
                      if (_busToFromRoute.isNotEmpty)
                        Polyline(
                          points: _busToFromRoute,
                          color: Colors.green,
                          strokeWidth: 5,
                        ),
                    ],
                  ),

                  // 🔵 BLUE: From → To
                  PolylineLayer(
                    polylines: [
                      if (_fromToRoute.isNotEmpty)
                        Polyline(
                          points: _fromToRoute,
                          color: Colors.blue,
                          strokeWidth: 5,
                        ),
                    ],
                  ),

                  // 🚌 Bus marker
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 50,
                        height: 50,
                        point: _busPosition!,
                        child: const Icon(
                          Icons.directions_bus,
                          size: 40,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
    );
  }
}
