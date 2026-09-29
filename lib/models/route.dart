class RouteModel {
  final String id;
  final String name;
  final List<String> stops; // List of stop names or IDs
  final double startLat;
  final double startLng;
  final double endLat;
  final double endLng;

  RouteModel({
    required this.id,
    required this.name,
    required this.stops,
    required this.startLat,
    required this.startLng,
    required this.endLat,
    required this.endLng,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    return RouteModel(
      id: json['id'],
      name: json['name'],
      stops: List<String>.from(json['stops']),
      startLat: json['startLat'],
      startLng: json['startLng'],
      endLat: json['endLat'],
      endLng: json['endLng'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'stops': stops,
      'startLat': startLat,
      'startLng': startLng,
      'endLat': endLat,
      'endLng': endLng,
    };
  }
}
