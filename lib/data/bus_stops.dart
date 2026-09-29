class BusStop {
  final String name;
  final double latitude;
  final double longitude;

  const BusStop({
    required this.name,
    required this.latitude,
    required this.longitude,
  });
}

/// SINGLE SOURCE OF TRUTH FOR BUS STOPS
/// Region: Delhi – NCR
final List<BusStop> busStops = [
  BusStop(name: 'Anand Vihar ISBT', latitude: 28.646677, longitude: 77.315985),
  BusStop(
    name: 'Vaishali Metro Station',
    latitude: 28.645408,
    longitude: 77.339305,
  ),
  BusStop(name: 'Indirapuram', latitude: 28.646838, longitude: 77.369471),
  BusStop(
    name: 'Ghaziabad Bus Stand',
    latitude: 28.669157,
    longitude: 77.453758,
  ),
  BusStop(name: 'Noida City Center', latitude: 28.574389, longitude: 77.356993),
  BusStop(name: 'Laxmi Nagar', latitude: 28.636991, longitude: 77.277490),
  BusStop(name: 'Akshardham', latitude: 28.612673, longitude: 77.277262),
  BusStop(
    name: 'Raj Nagar Extension',
    latitude: 28.704059,
    longitude: 77.442806,
  ),

  BusStop(name: 'Modinagar', latitude: 28.829766, longitude: 77.570462),
];
