class CarRentalVehicleModel {
  final String id;
  final String name;
  final String category;
  final int capacity;
  final double dailyPrice;
  final String transmission;
  final String fuelType;
  final String mileageLimit;
  final double depositAmount;
  final String conditions;
  final String image;
  final String description;

  CarRentalVehicleModel({
    required this.id,
    required this.name,
    required this.category,
    required this.capacity,
    required this.dailyPrice,
    required this.transmission,
    required this.fuelType,
    required this.mileageLimit,
    required this.depositAmount,
    required this.conditions,
    required this.image,
    required this.description,
  });

  factory CarRentalVehicleModel.fromJson(Map<String, dynamic> json) {
    return CarRentalVehicleModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? 'Sedan',
      capacity: json['capacity'] ?? 5,
      dailyPrice: (json['dailyPrice'] as num?)?.toDouble() ?? 3000.0,
      transmission: json['transmission'] ?? 'Automatic',
      fuelType: json['fuelType'] ?? 'Octane',
      mileageLimit: json['mileageLimit'] ?? '150 km/day',
      depositAmount: (json['depositAmount'] as num?)?.toDouble() ?? 10000.0,
      conditions: json['conditions'] ?? '',
      image: json['image'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class CarRentalBookingModel {
  final String id;
  final String userId;
  final String userName;
  final String userPhone;
  final String vehicleId;
  final String vehicleName;
  final String category;
  final String vehicleImage;
  final int capacity;
  final String transmission;
  final String fuelType;
  final String startDate;
  final String endDate;
  final int durationDays;
  final double dailyRate;
  final String driverOption; // 'self-drive' | 'with-driver'
  final double driverFeePerDay;
  final double totalPrice;
  final String additionalNotes;
  final String status;
  final String createdAt;

  CarRentalBookingModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userPhone,
    required this.vehicleId,
    required this.vehicleName,
    required this.category,
    required this.vehicleImage,
    required this.capacity,
    required this.transmission,
    required this.fuelType,
    required this.startDate,
    required this.endDate,
    required this.durationDays,
    required this.dailyRate,
    required this.driverOption,
    required this.driverFeePerDay,
    required this.totalPrice,
    this.additionalNotes = '',
    required this.status,
    required this.createdAt,
  });

  factory CarRentalBookingModel.fromJson(Map<String, dynamic> json) {
    return CarRentalBookingModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      userPhone: json['userPhone'] ?? '',
      vehicleId: json['vehicleId'] ?? '',
      vehicleName: json['vehicleName'] ?? '',
      category: json['category'] ?? '',
      vehicleImage: json['vehicleImage'] ?? '',
      capacity: json['capacity'] ?? 5,
      transmission: json['transmission'] ?? 'Automatic',
      fuelType: json['fuelType'] ?? 'Octane',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      durationDays: json['durationDays'] ?? 1,
      dailyRate: (json['dailyRate'] as num?)?.toDouble() ?? 0.0,
      driverOption: json['driverOption'] ?? 'self-drive',
      driverFeePerDay: (json['driverFeePerDay'] as num?)?.toDouble() ?? 0.0,
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      additionalNotes: json['additionalNotes'] ?? '',
      status: json['status'] ?? 'pending',
      createdAt: json['createdAt'] ?? '',
    );
  }
}
