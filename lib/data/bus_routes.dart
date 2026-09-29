import 'bus_stops.dart';

class BusRoute {
  final String routeId;
  final String name;
  final List<BusStop> stops;

  const BusRoute({
    required this.routeId,
    required this.name,
    required this.stops,
  });

  /// Check if route contains From → To in correct order
  bool serves(String from, String to) {
    final fromIndex = stops.indexWhere((s) => s.name == from);
    final toIndex = stops.indexWhere((s) => s.name == to);
    return fromIndex != -1 && toIndex != -1 && fromIndex < toIndex;
  }
}

/// ALL AVAILABLE ROUTES
final List<BusRoute> busRoutes = [
  BusRoute(
    routeId: 'route_1',
    name: 'Anand Vihar → Noida',
    stops: [
      busStops[0], // Anand Vihar ISBT
      busStops[1], // Vaishali
      busStops[2], // Indirapuram
      busStops[4], // Noida City Center
    ],
  ),
  BusRoute(
    routeId: 'route_2',
    name: 'Ghaziabad → Delhi',
    stops: [
      busStops[3], // Ghaziabad Bus Stand
      busStops[7], // Raj Nagar Extension
      busStops[0], // Anand Vihar ISBT
      busStops[5], // Laxmi Nagar
    ],
  ),

  BusRoute(
    routeId: 'route_3',
    name: 'Ghaziabad → Delhi',
    stops: [
      busStops[8], // Modinagar
      busStops[3], // Ghaziabad Bus Stand
      busStops[7], // Raj Nagar Extension
      busStops[0], // Anand Vihar ISBT
      busStops[5], // Laxmi Nagar
    ],
  ),
];
