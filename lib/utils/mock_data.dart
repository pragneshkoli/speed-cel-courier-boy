import 'dart:convert';
import '../../models/models.dart';

class MockData {
  // Mock user credentials for login
  static final Map<String, String> _userCredentials = {
    'delivery1@example.com': 'password123',
    'delivery2@example.com': 'password123',
    'meet@gmail.com': 'meet@123',
  };

  // Mock user data
  static final Map<String, User> _users = {
    'delivery1@example.com': User(
      id: 'usr_001',
      email: 'delivery1@example.com',
      name: 'John Delivery',
      role: 'delivery',
      token: '',
    ),
    'meet@gmail.com': User(
      id: 'usr_0010',
      email: 'meet@gmail.com',
      name: 'Meet',
      role: 'delivery',token: '',
    ),
    'delivery2@example.com': User(
      id: 'usr_002',
      email: 'delivery2@example.com',
      name: 'Sarah Express',
      role: 'delivery',token: '',
    ),
  };

  // Mock couriers data
  static final Map<String, List<Courier>> _userCouriers = {
    'usr_001': _generateCouriersForUser('usr_001'),
    'usr_002': _generateCouriersForUser('usr_002'),
    'usr_0010': _generateCouriersForUser('usr_0010'),
  };

  // Simulate login API
  static Future<Map<String, dynamic>> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    print('Login attempt: $email, $password');
    if (!_userCredentials.containsKey(email) || _userCredentials[email] != password) {
      return {
        'success': false,
        'message': 'Invalid email or password',
        'user': null,
      };
    }

    return {
      'success': true,
      'message': 'Login successful',
      'user': _users[email]!.toJson(),
    };
  }

  // Simulate get couriers API
  static Future<List<Courier>> getCouriers(String userId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    return _userCouriers[userId] ?? [];
  }

  // Simulate update courier status API
  static Future<bool> updateCourierStatus(
      String courierId, String status, DateTime? deliveredDate) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Find the courier in all user lists
    for (var userCouriers in _userCouriers.entries) {
      for (var i = 0; i < userCouriers.value.length; i++) {
        if (userCouriers.value[i].id == courierId) {
          // Update the courier status
          _userCouriers[userCouriers.key]![i] = userCouriers.value[i].copyWith(
            status: status,
            deliveredDate: deliveredDate,
          );
          return true;
        }
      }
    }

    return false;
  }

  // Generate mock couriers for a user
  static List<Courier> _generateCouriersForUser(String userId) {
    final List<Courier> couriers = [];

    // Create different packages based on user ID to simulate different assignments
    final int baseCount = userId == 'usr_001' ? 0 : 8;

    couriers.add(Courier(
      id: 'cour_${baseCount + 1}',
      trackingId: 'S-250507-001',
      weight: 10,
      packageType:"-",
      receiver: ReceiverSender(
        name: 'Jeemit',
        address: 'TRP Mall, Bopal, Ahmedabad',
        mobileNumber: '8396204021',
      ),
      sender: ReceiverSender(
        name: 'Krupesh',
        address: 'Thakkarnagar, Bapunagar, Ahmedabad',
        mobileNumber: '7329470217',
      ),
      status: 'pending' ,// 'pending' or 'delivered'
      // 2025-05-07T16:25:37.854+00:00
      assignedDate: DateTime.utc (2025, 5, 7, 16, 25, 37),
      deliveredDate: 1 <= 3 ? DateTime.now().subtract(Duration(hours: 1 * 2)) : null,
    ));

    couriers.add(Courier(
      id: 'cour_${baseCount +2}',
      trackingId: 'S-250507-002',
      weight: 8,
      packageType:"-",
      receiver: ReceiverSender(
        name: 'Pragnesh',
        address: 'Gangotri Circle, Nikol, Ahmedabad',
        mobileNumber: '7898521234',
      ),
      sender: ReceiverSender(
        name: 'Darshan',
        address: 'Sitaram Complex, Vallabh Vidhyanagar, Anand',
        mobileNumber: '7891237412',
      ),
      status: 'delivered',
      // 2025-05-07T16:25:37.854+00:00
      assignedDate: DateTime.utc (2025, 5, 7, 08, 38, 37),
      deliveredDate: null,
    ));

    return couriers;
  }
}