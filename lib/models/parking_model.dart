class ParkingModel {
  final String id;
  final String name;
  final String area;
  final String address;
  final double lat;
  final double lng;
  final double pricePerHour;
  final double rating;
  final int reviewCount;
  final int totalSpots;
  final int availableSpots;
  final String statusLevel;
  final String parkingType;
  final List<String> vehicleTypes;
  final List<String> facilities;
  final String openingHours;
  final String contactPhone;
  final String image;
  final String description;
  final bool isDemo;

  ParkingModel({
    required this.id,
    required this.name,
    required this.area,
    required this.address,
    required this.lat,
    required this.lng,
    required this.pricePerHour,
    required this.rating,
    required this.reviewCount,
    required this.totalSpots,
    required this.availableSpots,
    required this.statusLevel,
    required this.parkingType,
    required this.vehicleTypes,
    required this.facilities,
    required this.openingHours,
    required this.contactPhone,
    required this.image,
    required this.description,
    this.isDemo = true,
  });

  factory ParkingModel.fromJson(Map<String, dynamic> json) {
    final coords = json['coordinates'] as Map<String, dynamic>? ?? {};
    return ParkingModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      area: json['area'] ?? '',
      address: json['address'] ?? '',
      lat: (coords['lat'] as num?)?.toDouble() ?? 24.8949,
      lng: (coords['lng'] as num?)?.toDouble() ?? 91.8687,
      pricePerHour: (json['pricePerHour'] as num?)?.toDouble() ?? 30.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.5,
      reviewCount: json['reviewCount'] ?? 0,
      totalSpots: json['totalSpots'] ?? 30,
      availableSpots: json['availableSpots'] ?? 10,
      statusLevel: json['statusLevel'] ?? 'Available',
      parkingType: json['parkingType'] ?? 'Covered',
      vehicleTypes: List<String>.from(json['vehicleTypes'] ?? []),
      facilities: List<String>.from(json['facilities'] ?? []),
      openingHours: json['openingHours'] ?? '24/7',
      contactPhone: json['contactPhone'] ?? '',
      image: json['image'] ?? '',
      description: json['description'] ?? '',
      isDemo: json['isDemo'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'area': area,
      'address': address,
      'coordinates': {'lat': lat, 'lng': lng},
      'pricePerHour': pricePerHour,
      'rating': rating,
      'reviewCount': reviewCount,
      'totalSpots': totalSpots,
      'availableSpots': availableSpots,
      'statusLevel': statusLevel,
      'parkingType': parkingType,
      'vehicleTypes': vehicleTypes,
      'facilities': facilities,
      'openingHours': openingHours,
      'contactPhone': contactPhone,
      'image': image,
      'description': description,
      'isDemo': isDemo,
    };
  }
}
