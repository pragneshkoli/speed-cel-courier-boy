import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/models.dart';
import '../../widgets/delivery_confirmation_dialog.dart';

class CourierItem extends StatelessWidget {
  final Courier courier;
  final VoidCallback onStatusChanged;

  const CourierItem({
    super.key,
    required this.courier,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDelivered = courier.status == 'PACKAGE_DELIVERED';
    final formatter = DateFormat('MMM dd, yyyy');
    final timeFormatter = DateFormat('hh:mm a');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: isDelivered
            ? null
            : () {
          showDialog(
            context: context,
            builder: (context) => DeliveryConfirmationDialog(
              courier: courier,
              onDelivered: onStatusChanged,
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: isDelivered
                ? Theme.of(context).colorScheme.surface.withOpacity(0.5)
                : Theme.of(context).colorScheme.surface,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tracking ID and status
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.local_shipping,
                              size: 20,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              courier.trackingId,
                              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          // 'Package: ${courier.packageType} (${courier.weight} kg)',
                          'Package weight: ${courier.weight} kg',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  // Status chip
                  Chip(
                    label: Text(
                      isDelivered ? 'Delivered' : 'Pending',
                      style: TextStyle(
                        color: isDelivered
                            ? Theme.of(context).colorScheme.onSecondary
                            : Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: isDelivered
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  ),
                ],
              ),
              const Divider(height: 24),
              // Animated content
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Receiver details
                    Text(
                      'Receiver',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    _buildContactRow(
                      context,
                      icon: Icons.person,
                      title: courier.receiver.name,
                    ),
                    const SizedBox(height: 4),
                    _buildContactRow(
                      context,
                      icon: Icons.phone,
                      title: courier.receiver.mobileNumber,
                    ),
                    const SizedBox(height: 4),
                    _buildContactRow(
                      context,
                      icon: Icons.location_on,
                      title: courier.receiver.address,
                    ),
                    const SizedBox(height: 16),

                    // Sender details
                    Text(
                      'Sender',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    _buildContactRow(
                      context,
                      icon: Icons.person,
                      title: courier.sender.name,
                    ),
                    const SizedBox(height: 4),
                    _buildContactRow(
                      context,
                      icon: Icons.phone,
                      title: courier.sender.mobileNumber,
                    ),
                    const SizedBox(height: 4),
                    _buildContactRow(
                      context,
                      icon: Icons.location_on,
                      title: courier.sender.address,
                    ),
                    const SizedBox(height: 16),

                    // Dates
                    _buildDateRow(
                      context,
                      label: 'Assigned',
                      date: courier.assignedDate,
                      formatter: formatter,
                      timeFormatter: timeFormatter,
                    ),
                    if (isDelivered && courier.deliveredDate != null) ...[
                      const SizedBox(height: 4),
                      _buildDateRow(
                        context,
                        label: 'Delivered',
                        date: courier.deliveredDate!,
                        formatter: formatter,
                        timeFormatter: timeFormatter,
                        isDelivered: true,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Action button
              if (!isDelivered) ...[
                const Divider(height: 24),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => DeliveryConfirmationDialog(
                          courier: courier,
                          onDelivered: onStatusChanged,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    icon: Icon(
                      Icons.check_circle_outline,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    label: const Text('Confirm Delivery'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactRow(BuildContext context, {required IconData icon, required String title}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildDateRow(BuildContext context, {required String label, required DateTime date, required DateFormat formatter, required DateFormat timeFormatter, bool isDelivered = false}) {
    return Row(
      children: [
        Icon(
          isDelivered ? Icons.check_circle : Icons.schedule,
          size: 16,
          color: isDelivered
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ${formatter.format(date)} at ${timeFormatter.format(date)}',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}