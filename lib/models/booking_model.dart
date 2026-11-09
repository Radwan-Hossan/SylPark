class BookingModel {
  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final String parkingId;
  final String parkingName;
  final String parkingArea;
  final String parkingAddress;
  final String parkingImage;
  final double pricePerHour;
  final String vehicleType;
  final String vehiclePlate;
  final String bookingDate;
  final String startTime;
  final String endTime;
  final int durationHours;
  final double totalPrice;
  final String notes;
  final String status; // 'ongoing' | 'completed' | 'cancelled'
  final String createdAt;
  final bool isDemo;

  BookingModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.parkingId,
    required this.parkingName,
    required this.parkingArea,
    required this.parkingAddress,
    required this.parkingImage,
    required this.pricePerHour,
    required this.vehicleType,
    required this.vehiclePlate,
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
    required this.durationHours,
    required this.totalPrice,
    this.notes = '',
    required this.status,
    required this.createdAt,
    this.isDemo = true,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      userEmail: json['userEmail'] ?? '',
      parkingId: json['parkingId'] ?? '',
      parkingName: json['parkingName'] ?? '',
      parkingArea: json['parkingArea'] ?? '',
      parkingAddress: json['parkingAddress'] ?? '',
      parkingImage: json['parkingImage'] ?? '',
      pricePerHour: (json['pricePerHour'] as num?)?.toDouble() ?? 30.0,
      vehicleType: json['vehicleType'] ?? 'Car',
      vehiclePlate: json['vehiclePlate'] ?? '',
      bookingDate: json['bookingDate'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      durationHours: json['durationHours'] ?? 1,
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      notes: json['notes'] ?? '',
      status: json['status'] ?? 'ongoing',
      createdAt: json['createdAt'] ?? '',
      isDemo: json['isDemo'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'parkingId': parkingId,
      'parkingName': parkingName,
      'parkingArea': parkingArea,
      'parkingAddress': parkingAddress,
      'parkingImage': parkingImage,
      'pricePerHour': pricePerHour,
      'vehicleType': vehicleType,
      'vehiclePlate': vehiclePlate,
      'bookingDate': bookingDate,
      'startTime': startTime,
      'endTime': endTime,
      'durationHours': durationHours,
      'totalPrice': totalPrice,
      'notes': notes,
      'status': status,
      'createdAt': createdAt,
      'isDemo': isDemo,
    };
  }

  BookingModel copyWith({String? status}) {
    return BookingModel(
      id: id,
      userId: userId,
      userName: userName,
      userEmail: userEmail,
      parkingId: parkingId,
      parkingName: parkingName,
      parkingArea: parkingArea,
      parkingAddress: parkingAddress,
      parkingImage: parkingImage,
      pricePerHour: pricePerHour,
      vehicleType: vehicleType,
      vehiclePlate: vehiclePlate,
      bookingDate: bookingDate,
      startTime: startTime,
      endTime: endTime,
      durationHours: durationHours,
      totalPrice: totalPrice,
      notes: notes,
      status: status ?? this.status,
      createdAt: createdAt,
      isDemo: isDemo,
    );
  }
}
