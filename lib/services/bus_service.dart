import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/bus.dart';

class BusService {
  /// Live GPS API (already working in your project)
  static const String _liveApiUrl = 'https://bus-ofn9.onrender.com/gps';

  static Bus? _cachedBus;

  /// Fetch live bus location
  Future<Bus> getLiveLocation() async {
    try {
      final response = await http.get(Uri.parse(_liveApiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final double lat = (data['lat'] as num).toDouble();
        final double lng = (data['lon'] as num).toDouble();

        /// First-time initialization
        _cachedBus ??= Bus(
          id: 'bus_1',
          routeId: 'route_1',
          busNumber: 'UP32 AB 1234',
          latitude: lat,
          longitude: lng,
          status: 'on_route',
          estimatedArrival: DateTime.now().add(const Duration(minutes: 10)),
          direction: 'towards_destination',
        );

        /// Smooth update using copyWith
        _cachedBus = _cachedBus!.copyWith(
          latitude: lat + _smallOffset(),
          longitude: lng + _smallOffset(),
          estimatedArrival: DateTime.now().add(const Duration(minutes: 8)),
        );

        return _cachedBus!;
      } else {
        throw Exception('Live API failed');
      }
    } catch (_) {
      /// Fallback (demo-safe)
      return _cachedBus ??
          Bus(
            id: 'fallback_bus',
            routeId: 'route_fallback',
            busNumber: 'Demo Bus',
            latitude: 28.646677,
            longitude: 77.315985,
            status: 'delayed',
            estimatedArrival: DateTime.now().add(const Duration(minutes: 15)),
            direction: 'towards_destination',
          );
    }
  }

  /// Small random offset to simulate movement
  double _smallOffset() {
    return (Random().nextDouble() - 0.5) * 0.0003;
  }
}
