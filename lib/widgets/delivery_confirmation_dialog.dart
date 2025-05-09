import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speed_cel_courier_boy_app/providers/auth_provider.dart';
import '../models/models.dart';
import '../providers/courier_provider.dart';
import 'package:http/http.dart' as http;

class DeliveryConfirmationDialog extends StatefulWidget {
  final Courier courier;
  final VoidCallback onDelivered;

  const DeliveryConfirmationDialog({
    super.key,
    required this.courier,
    required this.onDelivered,
  });

  @override
  State<DeliveryConfirmationDialog> createState() =>
      _DeliveryConfirmationDialogState();
}

class _DeliveryConfirmationDialogState extends State<DeliveryConfirmationDialog>
    with SingleTickerProviderStateMixin {
  final _mobileController = TextEditingController();
  String _errorMessage = '';
  bool _isVerifying = false;
  bool _isVerified = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _verifyMobile() async {
    // /order/:orderId/status
    try {
      final mobileNumber = _mobileController.text.trim();
      if (mobileNumber.isEmpty) {
        setState(() {
          _errorMessage = 'Please enter mobile number';
          _isVerifying = false;
        });
        return;
      }
      if (mobileNumber.length!=10) {
        setState(() {
          _errorMessage = 'Please enter valid mobile number';
          _isVerifying = false;
        });
        return;
      }
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? "";
      if (token.isEmpty) {
        return;
      }
      var headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };
      var requestBody = {
        "status": "PACKAGE_DELIVERED",
        "mobile": _mobileController.text
      };
      var request = http.Request('PUT', Uri.parse('http://localhost:3000/courier-boy/order/${widget.courier.id}/status'));
      request.body = json.encode(requestBody);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String res = await response.stream.bytesToString();
      Map<String, dynamic> responseMap = jsonDecode(res);

      if (response.statusCode == 200) {
        setState(() {
          _isVerified = true;
          _isVerifying = false;
        });
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        CourierProvider courierProvider = Provider.of<CourierProvider>(context, listen: false);
        courierProvider.fetchCouriers(authProvider.user!.id, context);
        // Give some time to show success state before closing
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          Navigator.of(context).pop();
          widget.onDelivered();
        }

      } else {
        setState(() {
          _errorMessage = responseMap['message'];
          _isVerifying = false;
        });
      }


    } catch (e) {
      setState(() {
        _errorMessage =
            'Unexpected error occurred while verifying mobile number';
        _isVerifying = true;
      });
    }

    // final mobileNumber = _mobileController.text.trim();
    // if (mobileNumber.isEmpty) {
    //   setState(() {
    //     _errorMessage = 'Please enter mobile number';
    //     _isVerifying = false;
    //   });
    //   return;
    // }

    // Simulate a slight delay for verification
    // await Future.delayed(const Duration(milliseconds: 800));
    //
    // final success = await Provider.of<CourierProvider>(context, listen: false)
    //     .verifyCourierDelivery(widget.courier.id, mobileNumber);
    //
    // if (success) {
    //   setState(() {
    //     _isVerified = true;
    //     _isVerifying = false;
    //   });
    //   // Give some time to show success state before closing
    //   await Future.delayed(const Duration(seconds: 1));
    //   if (mounted) {
    //     Navigator.of(context).pop();
    //     widget.onDelivered();
    //   }
    // } else {
    //   setState(() {
    //     _errorMessage = 'Mobile number doesn\'t match receiver\'s number';
    //     _isVerifying = false;
    //   });
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          children: [
            Icon(
              _isVerified ? Icons.check_circle : Icons.local_shipping,
              color:
                  _isVerified
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.primary,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              _isVerified ? 'Delivery Verified!' : 'Confirm Delivery',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!_isVerified) ...[
                Text(
                  'Please verify the mobile number of the receiver to confirm delivery.',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.outline.withOpacity(0.5),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Package Details',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      _buildDetailRow(
                        'Tracking ID:',
                        widget.courier.trackingId,
                      ),
                      _buildDetailRow(
                        'Receiver:',
                        widget.courier.receiver.name,
                      ),
                      _buildDetailRow(
                        'Address:',
                        widget.courier.receiver.address,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  decoration: InputDecoration(
                    counterText: "",
                    labelText: 'Receiver\'s Mobile Number',
                    hintText: 'Enter the receiver\'s mobile number',
                    prefixIcon: Icon(
                      Icons.phone,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                if (_errorMessage.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Theme.of(context).colorScheme.error,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ] else ...[
                // Success message
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '🎉 Package delivered successfully!',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'The delivery status has been updated.',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              _isVerified ? 'Close' : 'Cancel',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          if (!_isVerified)
            ElevatedButton(
              onPressed: _isVerifying ? null : _verifyMobile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child:
                  _isVerifying
                      ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                      : const Text('Verify & Deliver'),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
