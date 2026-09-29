class Bus {
  final String id;
  final String routeId;
  final String busNumber;
  final double latitude;
  final double longitude;
  final String status; // on_route, delayed, arrived
  final DateTime estimatedArrival;
  final String direction;

  const Bus({
    required this.id,
    required this.routeId,
    required this.busNumber,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.estimatedArrival,
    required this.direction,
  });

  /// Creates a modified copy of Bus while keeping immutability
  Bus copyWith({
    String? id,
    String? routeId,
    String? busNumber,
    double? latitude,
    double? longitude,
    String? status,
    DateTime? estimatedArrival,
    String? direction,
  }) {
    return Bus(
      id: id ?? this.id,
      routeId: routeId ?? this.routeId,
      busNumber: busNumber ?? this.busNumber,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
      estimatedArrival: estimatedArrival ?? this.estimatedArrival,
      direction: direction ?? this.direction,
    );
  }

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      id: json['id'] ?? '',
      routeId: json['routeId'] ?? '',
      busNumber: json['busNumber'] ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      status: json['status'] ?? 'on_route',
      estimatedArrival: DateTime.parse(json['estimatedArrival']),
      direction: json['direction'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'routeId': routeId,
      'busNumber': busNumber,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'estimatedArrival': estimatedArrival.toIso8601String(),
      'direction': direction,
    };
  }
}
