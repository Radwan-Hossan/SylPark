import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../widgets/navigation/custom_floating_nav_bar.dart';
import '../bookings/my_bookings_screen.dart';
import '../home/home_screen.dart';
import '../parking/parking_explore_screen.dart';
import '../profile/profile_screen.dart';
import '../services/services_hub_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;

  const MainNavigationScreen({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(onTabChange: _onTabChanged),
      const ServicesHubScreen(),
      const ParkingExploreScreen(),
      MyBookingsScreen(onExploreTap: () => _onTabChanged(2)),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: CustomFloatingNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabChanged,
      ),
    );
  }
}
