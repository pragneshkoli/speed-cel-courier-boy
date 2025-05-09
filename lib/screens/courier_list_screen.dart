import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../providers/auth_provider.dart';
import '../../providers/courier_provider.dart';
import '../../widgets/courier_item.dart';
import 'login_screen.dart';
import 'package:http/http.dart' as http;

class CourierListScreen extends StatefulWidget {
  const CourierListScreen({super.key});

  @override
  State<CourierListScreen> createState() => _CourierListScreenState();
}

class _CourierListScreenState extends State<CourierListScreen>
    with SingleTickerProviderStateMixin {
  bool _isStarted = false;
  String _currentFilter = 'pending';
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // _loadCouriers();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _currentFilter = _tabController.index == 0 ? 'pending' : 'delivered';
        });
      }
    });
    final courierProvider = Provider.of<CourierProvider>(
      context,
      listen: false,
    );

    // Load data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final courierProvider = Provider.of<CourierProvider>(context, listen: false);

      if (authProvider.user != null) {
        courierProvider.fetchCouriers(authProvider.user!.id, context);
      } else {
        // Listen for changes when user becomes available
        authProvider.addListener(() {
          if (authProvider.user != null) {
            courierProvider.fetchCouriers(authProvider.user!.id, context);
          }
        });
      }
    });

  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadCouriers() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.user != null) {
      await Provider.of<CourierProvider>(
        context,
        listen: false,
      ).fetchCouriers(authProvider.user!.id, context);
    }
  }

  void _logout() async {
    await Provider.of<AuthProvider>(context, listen: false).logout();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  void _refreshList() {
    setState(() {
      // Just to refresh the UI
    });
  }

  Future<void> startDelivery() async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? "";
    if (token.isEmpty) {
      _logout();
      return;
    }

    ///start-delivery
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.Request(
      'PUT',
      Uri.parse('http://localhost:3000/courier-boy/start-delivery'),
    );

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    String res = await response.stream.bytesToString();
    Map<String, dynamic> responseMap = jsonDecode(res);
    if (response.statusCode == 200) {
      setState(() {
        _isStarted = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(responseMap['message']),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(responseMap['message']),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final courierProvider = Provider.of<CourierProvider>(context);
    final isWebPlatform = MediaQuery.of(context).size.width > 800;

    if (authProvider.user == null) {
      return const LoginScreen();
    }

    final filteredCouriers =
        _currentFilter == 'pending'
            ? courierProvider.pendingCouriers
            : courierProvider.deliveredCouriers;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Hero(
              tag: 'logo',
              child: Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.delivery_dining,
                  size: 24,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Text('Courier Deliveries'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCouriers,
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],

        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: const Icon(Icons.pending_actions),
              text: 'Pending (${courierProvider.pendingCouriers.length})',
            ),
            Tab(
              icon: const Icon(Icons.check_circle),
              text: 'Delivered (${courierProvider.deliveredCouriers.length})',
            ),
          ],
          labelColor: Theme.of(context).colorScheme.primary,
          indicatorColor: Theme.of(context).colorScheme.primary,
        ),
      ),
      body: SingleChildScrollView(
        // physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            // Start Delivery Button
            if (!_isStarted)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 8.0,
                ),
                child: ElevatedButton.icon(
                  onPressed: () {
                    startDelivery();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: Theme.of(context).colorScheme.onSecondary,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  icon: Icon(
                    Icons.play_arrow,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                  label: const Text('Start Delivery'),
                ),
              ),
            courierProvider.isLoading
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Loading couriers...',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                )
                : filteredCouriers.isEmpty
                ? _buildEmptyState(context)
                : AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child:
                      isWebPlatform
                          ? _buildWebLayout(context, filteredCouriers)
                          : Container(
                            // height: MediaQuery.of(context).size.height - 200,
                            child: _buildMobileLayout(
                              context,
                              filteredCouriers,
                            ),
                          ),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _currentFilter == 'pending'
                ? Icons.inventory_2
                : Icons.check_circle_outline,
            size: 80,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 24),
          Text(
            _currentFilter == 'pending'
                ? 'No pending deliveries!'
                : 'No completed deliveries yet',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            _currentFilter == 'pending'
                ? 'All packages have been delivered. Great job!'
                : 'Delivered packages will appear here',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (_currentFilter == 'pending')
            ElevatedButton.icon(
              onPressed: _loadCouriers,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              icon: Icon(
                Icons.refresh,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              label: const Text('Refresh List'),
            ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, List<dynamic> couriers) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () => _loadCouriers(),
        color: Theme.of(context).colorScheme.primary,
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 8, bottom: 24),
          itemCount: couriers.length,
          itemBuilder: (context, index) {
            return CourierItem(
              courier: couriers[index],
              onStatusChanged: _refreshList,
            );
          },
        ),
      ),
    );
  }

  Widget _buildWebLayout(BuildContext context, List<dynamic> couriers) {
    return RefreshIndicator(
      onRefresh: () => _loadCouriers(),
      color: Theme.of(context).colorScheme.primary,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth > 1200 ? 3 : 2;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _currentFilter == 'pending'
                              ? 'These are your pending deliveries. Tap on a package to verify and complete the delivery.'
                              : 'These are your completed deliveries. Great job!',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 1.1,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: couriers.length,
                  itemBuilder: (context, index) {
                    return CourierItem(
                      courier: couriers[index],
                      onStatusChanged: _refreshList,
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
