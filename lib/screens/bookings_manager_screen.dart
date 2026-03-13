import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../services/booking_api.dart';

class BookingsManagerScreen extends StatefulWidget {
  const BookingsManagerScreen({super.key});

  @override
  State<BookingsManagerScreen> createState() => _BookingsManagerScreenState();
}

class _BookingsManagerScreenState extends State<BookingsManagerScreen> {
  int _selectedTab = 0;
  final List<String> _tabs = ['Hamısı', 'Gözləyən', 'Təsdiqlənmiş', 'Tamamlanmış'];
  Timer? _pollTimer;
  bool _serverConnected = false;
  final Set<String> _knownIds = {};

  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  void _startPolling() {
    _pollTimer = Timer.periodic(const Duration(seconds: 3), (_) => _poll());
    _poll(); // immediate first fetch
  }

  Future<void> _poll() async {
    final serverBookings = await BookingApi.fetchBookings();
    if (!mounted) return;
    if (serverBookings.isEmpty) {
      if (_serverConnected) setState(() => _serverConnected = false);
      return;
    }
    setState(() => _serverConnected = true);

    // Find truly new bookings (not already in our list)
    final newOnes = serverBookings.where((sb) {
      final id = sb['id'] as String;
      return !_knownIds.contains(id) &&
          !_bookings.any((b) => b['id'] == id);
    }).toList();

    if (newOnes.isEmpty) return;

    setState(() {
      for (final nb in newOnes) {
        _knownIds.add(nb['id'] as String);
        _bookings.insert(0, {
          'name': nb['clientName'] ?? 'Yeni Xəstə',
          'service': nb['service'] ?? '',
          'date': nb['date'] ?? 'Bu gün',
          'time': nb['time'] ?? '',
          'duration': '45 min',
          'price': nb['price'] ?? '',
          'status': 'pending',
          'avatar': '👤',
          'phone': '+994 50 000 00 00',
          'id': nb['id'],
          'isNew': true,
        });
      }
    });

    if (newOnes.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          '📥 Yeni rezerv: ${newOnes.first['service']} — ${newOnes.first['clientName']}'),
        backgroundColor: BizColors.forest,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 4),
      ));
    }
  }

  void _declineBooking(Map<String, dynamic> b) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Rezervi Rədd Et', style: TextStyle(
          fontWeight: FontWeight.w800, color: BizColors.textPrimary)),
        content: Text('${b['name']} üçün ${b['service']} rədd edilsin?',
          style: const TextStyle(fontSize: 14, color: BizColors.textMuted)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Ləğv et', style: TextStyle(color: BizColors.textMuted)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _bookings.remove(b));
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('${b['name']} üçün rezerv rədd edildi'),
                backgroundColor: BizColors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ));
            },
            child: Text('Rədd et',
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
        title: const Text('Tamamlandı kimi işarələ', style: TextStyle(
          fontWeight: FontWeight.w800, color: BizColors.textPrimary)),
        content: Text('${b['name']} üçün ${b['service']} tamamlandı?',
          style: const TextStyle(fontSize: 14, color: BizColors.textMuted)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Ləğv et', style: TextStyle(color: BizColors.textMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => b['status'] = 'completed');
              BookingApi.updateStatus(b['id'] as String, 'completed');
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('${b['service']} tamamlandı'),
                backgroundColor: BizColors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ));
              // Show business feedback dialog
              Future.delayed(const Duration(milliseconds: 400), () {
                if (!mounted) return;
                _showBusinessFeedback(b);
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: BizColors.forest,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Təsdiqlə', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showBusinessFeedback(Map<String, dynamic> b) {
    int stars = 0;
    final noteCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlg) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Müştəri Qeydi Əlavə Et', style: TextStyle(
            fontWeight: FontWeight.w800, color: BizColors.textPrimary, fontSize: 15)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${b['name']} — ${b['service']}',
                style: const TextStyle(fontSize: 13, color: BizColors.textMuted)),
              const SizedBox(height: 16),
              const Text('Xidmət keyfiyyəti reytinqi:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: BizColors.textPrimary)),
              const SizedBox(height: 8),
              Row(
                children: List.generate(5, (i) => GestureDetector(
                  onTap: () => setDlg(() => stars = i + 1),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Icon(
                      i < stars ? Icons.star_rounded : Icons.star_outline_rounded,
                      size: 28,
                      color: i < stars ? const Color(0xFFFFB830) : BizColors.bgMuted,
                    ),
                  ),
                )),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: noteCtrl,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Bu müştəri haqqında qeyd (isteğe bağlı)...',
                  hintStyle: TextStyle(fontSize: 12, color: BizColors.textLight),
                  isDense: true,
                  contentPadding: const EdgeInsets.all(12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Keç', style: TextStyle(color: BizColors.textMuted)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text('Müştəri qeydi saxlanıldı'),
                  backgroundColor: BizColors.forest,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: BizColors.forest,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Göndər & Tamamla', style: TextStyle(color: Colors.white, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  void _callClient(Map<String, dynamic> b) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(b['name'] as String, style: const TextStyle(
          fontWeight: FontWeight.w800, color: BizColors.textPrimary)),
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
                  fontSize: 16, fontWeight: FontWeight.w800, color: BizColors.textPrimary)),
              ]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Bağla', style: TextStyle(color: BizColors.textMuted)),
          ),
        ],
      ),
    );
  }

  final List<Map<String, dynamic>> _bookings = [
    {
      'name': 'Rauf Məmmədov',
      'service': 'Diş Ağardılması',
      'date': 'Bu gün',
      'time': '09:30',
      'duration': '60 dəq',
      'price': '120 AZN',
      'status': 'confirmed',
      'avatar': '👨',
      'phone': '+994 50 123 45 67',
      'id': '#BRN-2841',
    },
    {
      'name': 'Leyla Əliyeva',
      'service': 'Diş Təmizlənməsi',
      'date': 'Bu gün',
      'time': '11:00',
      'duration': '45 dəq',
      'price': '55 AZN',
      'status': 'confirmed',
      'avatar': '👩',
      'phone': '+994 55 234 56 78',
      'id': '#BRN-2842',
    },
    {
      'name': 'Tural Hüseynov',
      'service': 'Breket Məsləhəti',
      'date': 'Bu gün',
      'time': '13:00',
      'duration': '30 dəq',
      'price': '40 AZN',
      'status': 'pending',
      'avatar': '👨',
      'phone': '+994 51 345 67 89',
      'id': '#BRN-2843',
    },
    {
      'name': 'Nigar Quliyeva',
      'service': 'Diş Dolğusu',
      'date': 'Bu gün',
      'time': '14:30',
      'duration': '50 dəq',
      'price': '80 AZN',
      'status': 'pending',
      'avatar': '👩',
      'phone': '+994 70 456 78 90',
      'id': '#BRN-2844',
    },
    {
      'name': 'Elşən Babayev',
      'service': 'Rentgen & Müayinə',
      'date': 'Sabah',
      'time': '10:00',
      'duration': '30 dəq',
      'price': '35 AZN',
      'status': 'confirmed',
      'avatar': '👨',
      'phone': '+994 77 567 89 01',
      'id': '#BRN-2845',
    },
    {
      'name': 'Aynur Həsənova',
      'service': 'Dərin Təmizlənmə',
      'date': 'Sabah',
      'time': '12:00',
      'duration': '60 dəq',
      'price': '90 AZN',
      'status': 'pending',
      'avatar': '👩',
      'phone': '+994 50 678 90 12',
      'id': '#BRN-2846',
    },
    {
      'name': 'Kamran Nəsirov',
      'service': 'Lazer Ağardması',
      'date': '6 Mar',
      'time': '15:00',
      'duration': '90 dəq',
      'price': '200 AZN',
      'status': 'completed',
      'avatar': '👨',
      'phone': '+994 55 789 01 23',
      'id': '#BRN-2830',
    },
    {
      'name': 'Günel İsmayılova',
      'service': 'Təmizlənmə + Ağardma',
      'date': '5 Mar',
      'time': '09:00',
      'duration': '90 dəq',
      'price': '150 AZN',
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

  String _todayLabel() {
    const months = ['Yan','Fev','Mar','Apr','May','İyn','İyl','Avq','Sen','Okt','Noy','Dek'];
    final now = DateTime.now();
    return '${now.day} ${months[now.month - 1]}';
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Rezervasiyalar', style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: BizColors.textPrimary,
            letterSpacing: -0.5,
          )),
          Row(children: [
            // Live sync indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _serverConnected
                    ? BizColors.green.withOpacity(0.12)
                    : BizColors.bgCard,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _serverConnected
                      ? BizColors.green.withOpacity(0.4)
                      : BizColors.bgMuted,
                  width: 1,
                ),
              ),
              child: Row(children: [
                Container(
                  width: 7, height: 7,
                  decoration: BoxDecoration(
                    color: _serverConnected ? BizColors.green : BizColors.textLight,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  _serverConnected ? 'Canlı' : 'Oflayn',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _serverConnected ? BizColors.green : BizColors.textLight,
                  ),
                ),
              ]),
            ),
            const SizedBox(width: 8),
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
                Text(_todayLabel(), style: TextStyle(
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
          colors: [BizColors.forest, BizColors.forestDeep],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: BizColors.shadowStrong,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _summaryItem('$pending', 'Gözləyən', BizColors.amber),
          Container(width: 1, height: 30, color: Colors.white.withOpacity(0.1)),
          _summaryItem('$confirmed', 'Təsdiqlənmiş', BizColors.green),
          Container(width: 1, height: 30, color: Colors.white.withOpacity(0.1)),
          _summaryItem('$completed', 'Tamamlanmış', BizColors.sage),
          Container(width: 1, height: 30, color: Colors.white.withOpacity(0.1)),
          _summaryItem('${_bookings.length}', 'Cəmi', Colors.white),
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
    final counts = [
      _bookings.length,
      _bookings.where((b) => b['status'] == 'pending').length,
      _bookings.where((b) => b['status'] == 'confirmed').length,
      _bookings.where((b) => b['status'] == 'completed').length,
    ];
    return SizedBox(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: _tabs.length,
        itemBuilder: (context, i) {
          final selected = _selectedTab == i;
          final label = '${_tabs[i]} (${counts[i]})';
          return GestureDetector(
            onTap: () => setState(() => _selectedTab = i),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
              child: Text(label, style: TextStyle(
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
            Text('Rezervasiya yoxdur', style: TextStyle(
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
        statusLabel = 'Təsdiqləndi';
        break;
      case 'pending':
        statusColor = BizColors.amber;
        statusLabel = 'Gözləyir';
        break;
      default:
        statusColor = BizColors.sageDark;
        statusLabel = 'Tamamlandı';
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
                            color: BizColors.textPrimary,
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
                    onTap: () {
                      setState(() => b['status'] = 'confirmed');
                      BookingApi.updateStatus(b['id'] as String, 'confirmed');
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: BizColors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text('✓ Təsdiqlə', style: TextStyle(
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
                        child: Text('✕ Rədd et', style: TextStyle(
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
                            Text('Müştərini Zəng Et', style: TextStyle(
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
                        child: Text('Tamamlandı', style: TextStyle(
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
