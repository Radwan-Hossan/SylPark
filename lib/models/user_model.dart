class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatar;
  final String? vehicleInfo;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatar = '',
    this.vehicleInfo,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      avatar: json['avatar'] ?? '',
      vehicleInfo: json['vehicleInfo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      if (vehicleInfo != null) 'vehicleInfo': vehicleInfo,
    };
  }

  UserModel copyWith({
    String? name,
    String? phone,
    String? avatar,
    String? vehicleInfo,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      vehicleInfo: vehicleInfo ?? this.vehicleInfo,
    );
  }
}
