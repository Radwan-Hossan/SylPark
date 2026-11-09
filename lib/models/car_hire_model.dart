class CarHireVehicleModel {
  final String id;
  final String name;
  final String type;
  final int capacity;
  final String luggageCapacity;
  final bool ac;
  final double baseFare;
  final String fareBasis;
  final List<String> features;
  final String image;
  final String description;

  CarHireVehicleModel({
    required this.id,
    required this.name,
    required this.type,
    required this.capacity,
    required this.luggageCapacity,
    required this.ac,
    required this.baseFare,
    required this.fareBasis,
    required this.features,
    required this.image,
    required this.description,
  });

  factory CarHireVehicleModel.fromJson(Map<String, dynamic> json) {
    return CarHireVehicleModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? 'Sedan',
      capacity: json['capacity'] ?? 4,
      luggageCapacity: json['luggageCapacity'] ?? '2 Bags',
      ac: json['ac'] ?? true,
      baseFare: (json['baseFare'] as num?)?.toDouble() ?? 2200.0,
      fareBasis: json['fareBasis'] ?? 'Per Trip',
      features: List<String>.from(json['features'] ?? []),
      image: json['image'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class CarHireBookingModel {
  final String id;
  final String userId;
  final String userName;
  final String userPhone;
  final String vehicleId;
  final String vehicleName;
  final String vehicleType;
  final String vehicleImage;
  final int capacity;
  final String pickupLocation;
  final String destination;
  final String travelDate;
  final String pickupTime;
  final int passengerCount;
  final double estimatedFare;
  final String additionalNotes;
  final String status;
  final String createdAt;
  final String driverAssigned;

  CarHireBookingModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userPhone,
    required this.vehicleId,
    required this.vehicleName,
    required this.vehicleType,
    required this.vehicleImage,
    required this.capacity,
    required this.pickupLocation,
    required this.destination,
    required this.travelDate,
    required this.pickupTime,
    required this.passengerCount,
    required this.estimatedFare,
    this.additionalNotes = '',
    required this.status,
    required this.createdAt,
    required this.driverAssigned,
  });

  factory CarHireBookingModel.fromJson(Map<String, dynamic> json) {
    return CarHireBookingModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      userPhone: json['userPhone'] ?? '',
      vehicleId: json['vehicleId'] ?? '',
      vehicleName: json['vehicleName'] ?? '',
      vehicleType: json['vehicleType'] ?? '',
      vehicleImage: json['vehicleImage'] ?? '',
      capacity: json['capacity'] ?? 4,
      pickupLocation: json['pickupLocation'] ?? '',
      destination: json['destination'] ?? '',
      travelDate: json['travelDate'] ?? '',
      pickupTime: json['pickupTime'] ?? '',
      passengerCount: json['passengerCount'] ?? 1,
      estimatedFare: (json['estimatedFare'] as num?)?.toDouble() ?? 0.0,
      additionalNotes: json['additionalNotes'] ?? '',
      status: json['status'] ?? 'pending',
      createdAt: json['createdAt'] ?? '',
      driverAssigned: json['driverAssigned'] ?? 'Demo Driver Assigned',
    );
  }
}
