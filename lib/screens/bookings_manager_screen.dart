import 'package:flutter/material.dart';
import '../theme/colors.dart';

class BookingsManagerScreen extends StatefulWidget {
  const BookingsManagerScreen({super.key});

  @override
  State<BookingsManagerScreen> createState() => _BookingsManagerScreenState();
}

class _BookingsManagerScreenState extends State<BookingsManagerScreen> {
  int _selectedTab = 0;
  final List<String> _tabs = ['All', 'Pending', 'Confirmed', 'Completed'];

  void _declineBooking(Map<String, dynamic> b) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Decline Booking', style: TextStyle(
          fontWeight: FontWeight.w800, color: Color(0xFF2C3528))),
        content: Text('Decline ${b['service']} for ${b['name']}?',
          style: const TextStyle(fontSize: 14, color: Color(0xFF6E7E68))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF7B9180))),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _bookings.remove(b));
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Booking declined for ${b['name']}'),
                backgroundColor: BizColors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ));
            },
            child: Text('Decline',
              style: TextStyle(color: BizColors.red, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _markComplete(Map<String, dynamic> b) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Mark as Complete', style: TextStyle(
          fontWeight: FontWeight.w800, color: Color(0xFF2C3528))),
        content: Text('Mark ${b['service']} for ${b['name']} as completed?',
          style: const TextStyle(fontSize: 14, color: Color(0xFF6E7E68))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF7B9180))),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => b['status'] = 'completed');
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('${b['service']} marked as complete'),
                backgroundColor: BizColors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: BizColors.forest,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Confirm', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _callClient(Map<String, dynamic> b) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(b['name'] as String, style: const TextStyle(
          fontWeight: FontWeight.w800, color: Color(0xFF2C3528))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: BizColors.sageBg,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.phone_rounded, color: BizColors.sageDark, size: 20),
                const SizedBox(width: 10),
                Text(b['phone'] as String, style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF2C3528))),
              ]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close', style: TextStyle(color: Color(0xFF7B9180))),
          ),
        ],
      ),
    );
  }

  final List<Map<String, dynamic>> _bookings = [
    {
      'name': 'Rauf Məmmədov',
      'service': 'Classic Haircut + Beard',
      'date': 'Today',
      'time': '10:00',
      'duration': '45 min',
      'price': '25 AZN',
      'status': 'confirmed',
      'avatar': '👨',
      'phone': '+994 50 123 45 67',
      'id': '#BRN-2841',
    },
    {
      'name': 'Leyla Əliyeva',
      'service': 'Hair Coloring',
      'date': 'Today',
      'time': '11:30',
      'duration': '90 min',
      'price': '65 AZN',
      'status': 'confirmed',
      'avatar': '👩',
      'phone': '+994 55 234 56 78',
      'id': '#BRN-2842',
    },
    {
      'name': 'Tural Hüseynov',
      'service': 'Classic Haircut',
      'date': 'Today',
      'time': '13:00',
      'duration': '30 min',
      'price': '15 AZN',
      'status': 'pending',
      'avatar': '👨',
      'phone': '+994 51 345 67 89',
      'id': '#BRN-2843',
    },
    {
      'name': 'Nigar Quliyeva',
      'service': 'Beard Trim',
      'date': 'Today',
      'time': '14:30',
      'duration': '20 min',
      'price': '10 AZN',
      'status': 'pending',
      'avatar': '👩',
      'phone': '+994 70 456 78 90',
      'id': '#BRN-2844',
    },
    {
      'name': 'Elşən Babayev',
      'service': 'Classic Haircut + Beard',
      'date': 'Tomorrow',
      'time': '10:00',
      'duration': '45 min',
      'price': '25 AZN',
      'status': 'confirmed',
      'avatar': '👨',
      'phone': '+994 77 567 89 01',
      'id': '#BRN-2845',
    },
    {
      'name': 'Aynur Həsənova',
      'service': 'Hair Treatment',
      'date': 'Tomorrow',
      'time': '12:00',
      'duration': '60 min',
      'price': '45 AZN',
      'status': 'pending',
      'avatar': '👩',
      'phone': '+994 50 678 90 12',
      'id': '#BRN-2846',
    },
    {
      'name': 'Kamran Nəsirov',
      'service': 'Classic Haircut',
      'date': 'Mar 6',
      'time': '15:00',
      'duration': '30 min',
      'price': '15 AZN',
      'status': 'completed',
      'avatar': '👨',
      'phone': '+994 55 789 01 23',
      'id': '#BRN-2830',
    },
    {
      'name': 'Günel İsmayılova',
      'service': 'Beard + Haircut',
      'date': 'Mar 5',
      'time': '09:00',
      'duration': '45 min',
      'price': '25 AZN',
      'status': 'completed',
      'avatar': '👩',
      'phone': '+994 51 890 12 34',
      'id': '#BRN-2829',
    },
  ];

  List<Map<String, dynamic>> get _filtered {
    if (_selectedTab == 0) return _bookings;
    final tagMap = {1: 'pending', 2: 'confirmed', 3: 'completed'};
    return _bookings.where((b) => b['status'] == tagMap[_selectedTab]).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BizColors.bgApp,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSummaryBar(),
            _buildTabs(),
            Expanded(child: _buildList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Bookings', style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Color(0xFF2C3528),
            letterSpacing: -0.5,
          )),
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: BizColors.bgCard,
                borderRadius: BorderRadius.circular(12),
                boxShadow: BizColors.shadow,
              ),
              child: Row(children: [
                Icon(Icons.calendar_today_rounded,
                  color: BizColors.forest, size: 14),
                const SizedBox(width: 6),
                Text('Mar 5', style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: BizColors.forest,
                )),
              ]),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSummaryBar() {
    final pending = _bookings.where((b) => b['status'] == 'pending').length;
    final confirmed = _bookings.where((b) => b['status'] == 'confirmed').length;
    final completed = _bookings.where((b) => b['status'] == 'completed').length;

    return Container(
      margin: const EdgeInsets.fromLTRB(18, 0, 18, 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2C3528), Color(0xFF1E2A1A)],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: BizColors.shadowStrong,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _summaryItem('$pending', 'Pending', BizColors.amber),
          Container(width: 1, height: 30, color: Colors.white.withOpacity(0.1)),
          _summaryItem('$confirmed', 'Confirmed', BizColors.green),
          Container(width: 1, height: 30, color: Colors.white.withOpacity(0.1)),
          _summaryItem('$completed', 'Completed', BizColors.sage),
          Container(width: 1, height: 30, color: Colors.white.withOpacity(0.1)),
          _summaryItem('${_bookings.length}', 'Total', Colors.white),
        ],
      ),
    );
  }

  Widget _summaryItem(String value, String label, Color color) {
    return Column(children: [
      Text(value, style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w900,
        color: color,
      )),
      Text(label, style: TextStyle(
        fontSize: 10,
        color: Colors.white.withOpacity(0.5),
        fontWeight: FontWeight.w600,
      )),
    ]);
  }

  Widget _buildTabs() {
    return SizedBox(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: _tabs.length,
        itemBuilder: (context, i) {
          final selected = _selectedTab == i;
          return GestureDetector(
            onTap: () => setState(() => _selectedTab = i),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? BizColors.forest : BizColors.bgCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selected
                      ? BizColors.forest
                      : BizColors.sage.withOpacity(0.25),
                ),
                boxShadow: selected ? BizColors.shadow : [],
              ),
              child: Text(_tabs[i], style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : BizColors.textMuted,
              )),
            ),
          );
        },
      ),
    );
  }

  Widget _buildList() {
    final list = _filtered;
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('📭', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            Text('No bookings here', style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: BizColors.textMuted,
            )),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
      itemCount: list.length,
      itemBuilder: (context, i) => _buildCard(list[i]),
    );
  }

  Widget _buildCard(Map<String, dynamic> b) {
    final status = b['status'] as String;
    Color statusColor;
    String statusLabel;
    switch (status) {
      case 'confirmed':
        statusColor = BizColors.green;
        statusLabel = 'Confirmed';
        break;
      case 'pending':
        statusColor = BizColors.amber;
        statusLabel = 'Pending';
        break;
      default:
        statusColor = BizColors.sageDark;
        statusLabel = 'Completed';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: BizColors.bgCard,
        borderRadius: BorderRadius.circular(20),
        boxShadow: BizColors.shadow,
        border: Border.all(
          color: statusColor.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 46, height: 46,
                  decoration: BoxDecoration(
                    color: BizColors.sageBg,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(child: Text(b['avatar'] as String,
                    style: const TextStyle(fontSize: 22))),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(b['name'] as String, style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF2C3528),
                          )),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(statusLabel, style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: statusColor,
                            )),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(b['service'] as String, style: TextStyle(
                        fontSize: 12,
                        color: BizColors.textMuted,
                      )),
                      const SizedBox(height: 5),
                      Row(children: [
                        Icon(Icons.access_time_rounded,
                          size: 12, color: BizColors.textLight),
                        const SizedBox(width: 3),
                        Text('${b['date']} • ${b['time']} • ${b['duration']}',
                          style: TextStyle(
                            fontSize: 11,
                            color: BizColors.textMuted,
                          )),
                        const Spacer(),
                        Text(b['price'] as String, style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: BizColors.forest,
                        )),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (status == 'pending')
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
              child: Row(children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => b['status'] = 'confirmed'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: BizColors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text('✓ Confirm', style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        )),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _declineBooking(b),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: BizColors.red.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: BizColors.red.withOpacity(0.2)),
                      ),
                      child: Center(
                        child: Text('✕ Decline', style: TextStyle(
                          color: BizColors.red,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        )),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          if (status == 'confirmed')
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
              child: Row(children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _callClient(b),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: BizColors.sageBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.phone_rounded,
                              color: BizColors.sageDark, size: 14),
                            const SizedBox(width: 6),
                            Text('Call Client', style: TextStyle(
                              color: BizColors.sageDark,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _markComplete(b),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: BizColors.forest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text('Mark Complete', style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        )),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
        ],
      ),
    );
  }
}
