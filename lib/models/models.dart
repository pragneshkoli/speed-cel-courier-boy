// User and Courier models combined for efficiency

class User {
  final String id;
  final String email;
  final String name;
  final String role;
  final String token;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['data']['id'] as String,
      email: json['data']['email'] as String,
      name: json['data']['name'] as String,
      role: json['data']['role'] as String,
      token: json['token'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'data': {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
    },
    'token': token,
  };
}

class Courier {
  final String id;
  final String trackingId;
  final double weight;
  final String packageType;
  final ReceiverSender receiver;
  final ReceiverSender sender;
  final String status;
  final DateTime assignedDate;
  final DateTime? deliveredDate;

  Courier({
    required this.id,
    required this.trackingId,
    required this.weight,
    required this.packageType,
    required this.receiver,
    required this.sender,
    required this.status,
    required this.assignedDate,
    this.deliveredDate,
  });

  Courier copyWith({
    String? id,
    String? trackingId,
    double? weight,
    String? packageType,
    ReceiverSender? receiver,
    ReceiverSender? sender,
    String? status,
    DateTime? assignedDate,
    DateTime? deliveredDate,
  }) {
    return Courier(
      id: id ?? this.id,
      trackingId: trackingId ?? this.trackingId,
      weight: weight ?? this.weight,
      packageType: packageType ?? this.packageType,
      receiver: receiver ?? this.receiver,
      sender: sender ?? this.sender,
      status: status ?? this.status,
      assignedDate: assignedDate ?? this.assignedDate,
      deliveredDate: deliveredDate ?? this.deliveredDate,
    );
  }

  factory Courier.fromJson(Map<String, dynamic> json) {
    return Courier(
      id: json['_id'] as String,
      trackingId: json['orderId'] as String,
      weight: (json['weight'] as num).toDouble(),
      packageType: "",
      receiver: ReceiverSender.fromJson(json['receiver'] as Map<String, dynamic>),
      sender: ReceiverSender.fromJson(json['sender'] as Map<String, dynamic>),
      status: json['status'] as String,
      assignedDate: DateTime.parse(json['updatedAt'] as String),
      deliveredDate: null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'trackingId': trackingId,
    'weight': weight,
    'packageType': packageType,
    'receiver': receiver.toJson(),
    'sender': sender.toJson(),
    'status': status,
    'assignedDate': assignedDate.toIso8601String(),
    'deliveredDate': deliveredDate?.toIso8601String(),
  };
}

class ReceiverSender {
  final String name;
  final String address;
  final String mobileNumber;

  ReceiverSender({
    required this.name,
    required this.address,
    required this.mobileNumber,
  });

  factory ReceiverSender.fromJson(Map<String, dynamic> json) {
    String address1 = json['address'] as String;
    String city = json['city'] as String;
    String area = json['area'] as String;
    return ReceiverSender(
      name: json['name'] as String,
      address: "$address1, $area, $city",
      mobileNumber: json['contact'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'address': address,
    'mobileNumber': mobileNumber,
  };
}