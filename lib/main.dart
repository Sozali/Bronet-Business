import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'screens/bookings_manager_screen.dart';
import 'screens/services_screen.dart';
import 'screens/schedule_screen.dart';
import 'screens/business_profile_screen.dart';

void main() {
  runApp(const BronetBusinessApp());
}

class BronetBusinessApp extends StatelessWidget {
  const BronetBusinessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "BRON'ET Business",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF0F5EC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFA8B6A1),
        ),
      ),
      home: const RootScreen(),
    );
  }
}

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _currentTab = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    BookingsManagerScreen(),
    ServicesScreen(),
    const ScheduleScreen(),
    const BusinessProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentTab],
      bottomNavigationBar: _buildNav(),
    );
  }

  Widget _buildNav() {
    final tabs = [
      {'icon': Icons.dashboard_rounded,       'label': 'Dashboard'},
      {'icon': Icons.calendar_month_rounded,  'label': 'Bookings'},
      {'icon': Icons.design_services_rounded, 'label': 'Services'},
      {'icon': Icons.schedule_rounded,        'label': 'Schedule'},
      {'icon': Icons.store_rounded,           'label': 'Profile'},
    ];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(
          color: const Color(0xFFA8B6A1).withOpacity(0.2))),
        boxShadow: [BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 20, offset: const Offset(0, -4),
        )],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(tabs.length, (i) {
              final active = _currentTab == i;
              return GestureDetector(
                onTap: () => setState(() => _currentTab = i),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: active
                        ? const Color(0xFFA8B6A1).withOpacity(0.15)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(tabs[i]['icon'] as IconData,
                        color: active
                            ? const Color(0xFF2C3528)
                            : const Color(0xFF9AAA94),
                        size: 22),
                      const SizedBox(height: 3),
                      Text(tabs[i]['label'] as String,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: active
                              ? const Color(0xFF2C3528)
                              : const Color(0xFF9AAA94),
                        )),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}