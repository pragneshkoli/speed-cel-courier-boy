import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speed_cel_courier_boy_app/screens/login_screen.dart';
import '../../models/models.dart';
import '../../utils/mock_data.dart';
import 'package:http/http.dart' as http;
class CourierProvider with ChangeNotifier {
  List<Courier> _couriers = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Courier> get couriers => _couriers;
  List<Courier> get pendingCouriers => _couriers.where((courier) => courier.status == 'PACKAGE_LEFT' || courier.status == 'PACKAGE_ON_THE_WAY').toList();
  List<Courier> get deliveredCouriers => _couriers.where((courier) => courier.status == 'PACKAGE_DELIVERED').toList();
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchCouriers(String userId,BuildContext context) async {
    print("fetching couriers");
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? "";
      if(token.isEmpty){
        return;
      }
      ///start-delivery
      var headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };
      var request = http.Request('GET', Uri.parse('http://localhost:3000/courier-boy/assigned-orders'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String res = await response.stream.bytesToString();
      Map<String, dynamic> responseMap = jsonDecode(res);
      if(response.statusCode == 200){
        _couriers = [];
        List<Courier> tempList = [];
        responseMap['data'].forEach((element) {
          tempList.add(Courier.fromJson(element));
        });
        _couriers.addAll(tempList);
        tempList.clear();
        notifyListeners();
      }else{
        if (response.statusCode == 401) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.remove('token');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
          return;
        }
        _errorMessage = responseMap['message'];
        notifyListeners();
      }
      // final fetchedCouriers = await MockData.getCouriers(userId);
      // _couriers = fetchedCouriers;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load couriers. Please try again.';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> verifyCourierDelivery(String courierId, String mobileNumber) async {
    final courier = _couriers.firstWhere((courier) => courier.id == courierId);

    // Check if the mobile number matches
    if (courier.receiver.mobileNumber != mobileNumber) {
      return false;
    }

    // Mark as delivered
    return await markCourierDelivered(courierId);
  }

  Future<bool> markCourierDelivered(String courierId) async {
    try {
      final success = await MockData.updateCourierStatus(
          courierId,
          'delivered',
          DateTime.now()
      );

      if (success) {
        // Update local state
        final index = _couriers.indexWhere((courier) => courier.id == courierId);
        if (index != -1) {
          _couriers[index] = _couriers[index].copyWith(
            status: 'delivered',
            deliveredDate: DateTime.now(),
          );
          notifyListeners();
        }
      }

      return success;
    } catch (e) {
      debugPrint('Error marking courier as delivered: $e');
      return false;
    }
  }

  Courier? getCourierById(String id) {
    try {
      return _couriers.firstWhere((courier) => courier.id == id);
    } catch (e) {
      return null;
    }
  }
}