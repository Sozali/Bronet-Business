import 'package:flutter/material.dart';
import 'dart:async';
import '../theme/colors.dart';
import '../services/booking_api.dart';
import '../services/auth_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedDay = 0;
  bool _isOpen = true;
  bool _loadingStatus = false;
  final List<String> _days = ['Bu gün', 'Sabah', 'Bu həftə'];

  // Real-time notification polling
  int _notifCount = 0;
  Timer? _pollTimer;
  final Set<String> _seenIds = {};

  // Break mode
  bool _onBreak = false;
  int _breakSecsLeft = 0;
  Timer? _breakTimer;

  // Revenue hiding
  bool _showRevenue = false;

  final List<Map<String, dynamic>> _bookings = [
    {
      'name': 'Rauf Məmmədov',
      'service': 'Diş Ağardılması',
      'time': '09:30',
      'duration': '60 dəq',
      'price': '120 AZN',
      'status': 'confirmed',
      'avatar': '👨',
    },
    {
      'name': 'Leyla Əliyeva',
      'service': 'Diş Təmizlənməsi',
      'time': '11:00',
      'duration': '45 dəq',
      'price': '55 AZN',
      'status': 'confirmed',
      'avatar': '👩',
    },
    {
      'name': 'Tural Hüseynov',
      'service': 'Diş Müayinəsi',
      'time': '13:00',
      'duration': '30 dəq',
      'price': '40 AZN',
      'status': 'pending',
      'avatar': '👨',
    },
    {
      'name': 'Nigar Rzayeva',
      'service': 'Diş Ağardılması',
      'time': '14:30',
      'duration': '60 dəq',
      'price': '120 AZN',
      'status': 'confirmed',
      'avatar': '👩',
    },
    {
      'name': 'Ismayil M.',
      'service': 'Diş Rentgeni',
      'time': '16:00',
      'duration': '30 dəq',
      'price': '35 AZN',
      'status': 'pending',
      'avatar': '👨',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadStatus();
    _seedAndStartPolling();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _breakTimer?.cancel();
    super.dispose();
  }

  // ── Break helpers ─────────────────────────────────────────────────
  String get _breakLabel {
    final m = _breakSecsLeft ~/ 60;
    final s = _breakSecsLeft % 60;
    return '${m.toString().padLeft(2,'0')}:${s.toString().padLeft(2,'0')}';
  }

  void _startBreak(int minutes, {String? reason}) {
    setState(() {
      _onBreak = true;
      _breakSecsLeft = minutes * 60;
      _isOpen = false;
    });
    BookingApi.setBusinessOpen(false);
    final msg = reason != null && reason.isNotEmpty
        ? '☕ Fasilə başladı ($reason) — $minutes dəq'
        : '☕ Fasilə başladı — $minutes dəq';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: const Color(0xFFD48A00),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
    _breakTimer?.cancel();
    _breakTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _breakSecsLeft--);
      if (_breakSecsLeft <= 0) {
        _breakTimer?.cancel();
        setState(() { _onBreak = false; _isOpen = true; });
        BookingApi.setBusinessOpen(true);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('☕ Fasilə bitdi — Biznes yenidən AÇIQDIR 🟢'),
          backgroundColor: BizColors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ));
      }
    });
  }

  void _endBreakEarly() {
    _breakTimer?.cancel();
    setState(() { _onBreak = false; _isOpen = true; _breakSecsLeft = 0; });
    BookingApi.setBusinessOpen(true);
  }

  void _showBreakPicker() {
    final presets = [15, 30, 45, 60, 120];
    final customCtrl = TextEditingController();
    final reasonCtrl = TextEditingController();
    int? selectedPreset;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 36),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(child: Container(width: 40, height: 4,
                decoration: BoxDecoration(color: BizColors.bgMuted,
                  borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 20),
              const Center(child: Text('☕ Fasilə Al', style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w900, color: BizColors.textPrimary))),
              const SizedBox(height: 6),
              Center(child: Text('Fasilə zamanı müştərilər rezerv edə bilməyəcək',
                style: TextStyle(fontSize: 12, color: BizColors.textMuted),
                textAlign: TextAlign.center)),
              const SizedBox(height: 20),
              // Preset chips
              Wrap(spacing: 8, children: presets.map((min) {
                final label = min < 60 ? '$min min' : '${min ~/ 60}h';
                final sel = selectedPreset == min;
                return GestureDetector(
                  onTap: () => setSheet(() { selectedPreset = min; customCtrl.clear(); }),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: sel ? BizColors.forest : BizColors.bgApp,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: sel ? BizColors.forest : BizColors.sage.withOpacity(0.3)),
                    ),
                    child: Text(label, style: TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w700,
                      color: sel ? Colors.white : BizColors.textPrimary)),
                  ),
                );
              }).toList()),
              const SizedBox(height: 16),
              // Custom time row
              const Text('Xüsusi müddət', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: BizColors.textMuted)),
              const SizedBox(height: 8),
              Row(children: [
                SizedBox(
                  width: 80,
                  child: TextField(
                    controller: customCtrl,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setSheet(() => selectedPreset = null),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      hintText: 'min',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text('min', style: TextStyle(fontSize: 13, color: BizColors.textMuted)),
                const SizedBox(width: 12),
                Expanded(child: ElevatedButton(
                  onPressed: () {
                    final mins = int.tryParse(customCtrl.text.trim());
                    if (mins != null && mins > 0) {
                      Navigator.pop(ctx);
                      _startBreak(mins, reason: reasonCtrl.text.trim().isEmpty ? null : reasonCtrl.text.trim());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD48A00),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: const Text('Fasilə Başlat', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                )),
              ]),
              const SizedBox(height: 14),
              // Reason field
              TextField(
                controller: reasonCtrl,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  hintText: 'Səbəb (isteğe bağlı, məs. Nahar fasiləsi)',
                  hintStyle: TextStyle(fontSize: 12, color: BizColors.textLight),
                ),
              ),
              const SizedBox(height: 16),
              // Start Custom Break button (uses preset or custom)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: selectedPreset != null ? () {
                    Navigator.pop(ctx);
                    _startBreak(selectedPreset!, reason: reasonCtrl.text.trim().isEmpty ? null : reasonCtrl.text.trim());
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BizColors.forest,
                    disabledBackgroundColor: BizColors.bgMuted,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    selectedPreset != null
                        ? '${selectedPreset! < 60 ? "$selectedPreset dəq" : "${selectedPreset! ~/ 60}s"} Fasilə Başlat'
                        : 'Yuxarıdan müddət seçin',
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800)),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Future<void> _loadStatus() async {
    final open = await BookingApi.getBusinessOpen();
    if (open != null && mounted) setState(() => _isOpen = open);
  }

  Future<void> _seedAndStartPolling() async {
    // Seed existing bookings silently (no notif for already-existing ones)
    final existing = await BookingApi.fetchBookings();
    for (final b in existing) {
      _seenIds.add(b['id']?.toString() ?? '');
    }
    // Now start polling for NEW ones
    _pollTimer = Timer.periodic(const Duration(seconds: 3), (_) => _pollBookings());
  }

  Future<void> _pollBookings() async {
    final bookings = await BookingApi.fetchBookings();
    if (!mounted) return;
    for (final b in bookings) {
      final id = b['id']?.toString() ?? '';
      if (id.isNotEmpty && !_seenIds.contains(id)) {
        _seenIds.add(id);
        setState(() => _notifCount++);
        final service = b['service'] ?? 'Xidmət';
        final client = b['clientName'] ?? 'Müştəri';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('🔔 Yeni rezerv: $service — $client'),
          backgroundColor: BizColors.forest,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ));
      }
    }
  }

  Future<void> _toggleOpen(bool value) async {
    setState(() => _loadingStatus = true);
    final result = await BookingApi.setBusinessOpen(value);
    if (mounted) {
      setState(() {
        _isOpen = result ?? value;
        _loadingStatus = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(_isOpen
            ? '🟢 Biznes indi AÇIQDIR — rezervlər qəbul edilir'
            : '🔴 Biznes indi BAĞLIDIR'),
        backgroundColor: _isOpen ? BizColors.green : BizColors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BizColors.bgApp,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildOpenCloseToggle(),
              _buildStatsRow(),
              _buildRevenueCard(),
              _buildDaySelector(),
              _buildBookingsList(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [BizColors.forest, BizColors.forestDeep],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                width: 32, height: 32,
                decoration: BoxDecoration(
                  color: BizColors.sage.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Center(
                  child: Text('B', style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  )),
                ),
              ),
              const SizedBox(width: 8),
              RichText(text: const TextSpan(children: [
                TextSpan(text: "BRON'", style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                )),
                TextSpan(text: "ET ", style: TextStyle(
                  color: BizColors.sage,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                )),
                TextSpan(text: "Business", style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                )),
              ])),
            ]),
            const SizedBox(height: 4),
            Text(BizAuthService.businessName,
              style: TextStyle(
                color: Colors.white.withOpacity(0.55),
                fontSize: 12,
              )),
          ]),
          Row(children: [
            GestureDetector(
              onTap: () => setState(() => _notifCount = 0),
              child: Stack(clipBehavior: Clip.none, children: [
                Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const Center(
                    child: Icon(Icons.notifications_rounded,
                      color: Colors.white, size: 18),
                  ),
                ),
                if (_notifCount > 0)
                  Positioned(
                    top: -3, right: -3,
                    child: Container(
                      width: 16, height: 16,
                      decoration: BoxDecoration(
                        color: BizColors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: BizColors.forest, width: 2),
                      ),
                      child: Center(child: Text('$_notifCount',
                        style: const TextStyle(color: Colors.white, fontSize: 7,
                          fontWeight: FontWeight.w900))),
                    ),
                  ),
              ]),
            ),
            const SizedBox(width: 8),
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                color: BizColors.sage.withOpacity(0.25),
                borderRadius: BorderRadius.circular(19),
              ),
              child: const Center(
                child: Text('🦷', style: TextStyle(fontSize: 18)),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildOpenCloseToggle() {
    final Color activeColor = _onBreak
        ? const Color(0xFFD48A00)
        : (_isOpen ? BizColors.green : BizColors.red);

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 4),
      child: Column(children: [
        // ── Main status card ──────────────────────────────────────
        GestureDetector(
          onTap: (_loadingStatus || _onBreak) ? null : () => _toggleOpen(!_isOpen),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: activeColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: activeColor.withOpacity(0.3), width: 1.5),
              boxShadow: BizColors.shadow,
            ),
            child: Row(children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: activeColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Center(child: Icon(
                  _onBreak ? Icons.coffee_rounded
                      : (_isOpen ? Icons.store_rounded : Icons.store_mall_directory_outlined),
                  color: activeColor, size: 22,
                )),
              ),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  _onBreak ? 'Fasilədə — $_breakLabel sonra qayıdır'
                      : (_isOpen ? 'Biznes Açıqdır' : 'Biznes Bağlıdır'),
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: activeColor),
                ),
                const SizedBox(height: 2),
                Text(
                  _onBreak ? '"Fasil. Bitir" düyməsinə basın'
                      : (_isOpen ? 'Müştərilərdən yeni rezervlər qəbul edilir'
                          : 'Hazırda yeni rezervlər qəbul edilmir'),
                  style: TextStyle(fontSize: 11, color: BizColors.textMuted),
                ),
              ])),
              _loadingStatus
                  ? SizedBox(width: 24, height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2, color: activeColor))
                  : _onBreak
                      ? const SizedBox.shrink()
                      : Switch(
                          value: _isOpen,
                          onChanged: _toggleOpen,
                          activeColor: BizColors.green,
                          activeTrackColor: BizColors.green.withOpacity(0.3),
                          inactiveThumbColor: BizColors.red,
                          inactiveTrackColor: BizColors.red.withOpacity(0.25),
                        ),
            ]),
          ),
        ),

        // ── Break buttons ─────────────────────────────────────────
        const SizedBox(height: 10),
        Row(children: [
          if (_onBreak) ...[
            Expanded(child: GestureDetector(
              onTap: _endBreakEarly,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: BizColors.green.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: BizColors.green.withOpacity(0.3)),
                ),
                child: Center(child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.store_rounded, size: 15, color: BizColors.green),
                  const SizedBox(width: 6),
                  Text('Fasil. Bitir', style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w700, color: BizColors.green)),
                ])),
              ),
            )),
          ] else ...[
            Expanded(child: GestureDetector(
              onTap: _isOpen ? _showBreakPicker : null,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _isOpen
                      ? const Color(0xFFD48A00).withOpacity(0.10)
                      : BizColors.bgMuted,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _isOpen
                        ? const Color(0xFFD48A00).withOpacity(0.3)
                        : Colors.transparent),
                ),
                child: Center(child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text('☕', style: TextStyle(fontSize: 14,
                    color: _isOpen ? null : BizColors.textLight)),
                  const SizedBox(width: 6),
                  Text('Fasilə Al', style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w700,
                    color: _isOpen ? const Color(0xFFD48A00) : BizColors.textLight)),
                ])),
              ),
            )),
          ],
        ]),
      ]),
    );
  }

  Widget _buildStatsRow() {
    final stats = [
      {'label': 'Bu gün', 'value': '5', 'sub': 'rezerv', 'icon': Icons.calendar_today_rounded, 'color': 0xFF4A90D9, 'hideRevenue': false},
      {'label': 'Gəlir', 'value': '140₼', 'sub': 'bu gün', 'icon': Icons.payments_rounded, 'color': 0xFF3DAD7F, 'hideRevenue': true},
      {'label': 'Gözləyən', 'value': '2', 'sub': 'təsdiq üçün', 'icon': Icons.pending_rounded, 'color': 0xFFFFB830, 'hideRevenue': false},
      {'label': 'Reytinq', 'value': '4.9', 'sub': '318 rəy', 'icon': Icons.star_rounded, 'color': 0xFFFF4D6A, 'hideRevenue': false},
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 8),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.2,
        children: stats.map((s) {
          final color = Color(s['color'] as int);
          final isRevenue = s['hideRevenue'] as bool;
          final displayValue = isRevenue && !_showRevenue ? '•••' : s['value'] as String;
          return GestureDetector(
            onTap: isRevenue ? () => setState(() => _showRevenue = !_showRevenue) : null,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: BizColors.bgCard,
                borderRadius: BorderRadius.circular(16),
                boxShadow: BizColors.shadow,
              ),
              child: Row(children: [
                Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Center(
                    child: Icon(s['icon'] as IconData,
                      color: color, size: 18),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(children: [
                      Text(displayValue, style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: BizColors.forest,
                      )),
                      if (isRevenue) ...[
                        const SizedBox(width: 4),
                        Icon(_showRevenue ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                          size: 12, color: BizColors.textLight),
                      ],
                    ]),
                    Text(s['sub'] as String, style: TextStyle(
                      fontSize: 9,
                      color: BizColors.textMuted,
                      fontWeight: FontWeight.w600,
                    )),
                  ],
                )),
              ]),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRevenueCard() {
    String revVal(String v) => _showRevenue ? v : '•••';
    return Container(
      margin: const EdgeInsets.fromLTRB(18, 8, 18, 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: BizColors.bgCard,
        borderRadius: BorderRadius.circular(20),
        boxShadow: BizColors.shadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Text('Həftəlik Gəlir', style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: BizColors.forest,
                )),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => setState(() => _showRevenue = !_showRevenue),
                  child: Icon(
                    _showRevenue ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                    size: 16, color: BizColors.textLight),
                ),
              ]),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: BizColors.green.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(children: [
                  Icon(Icons.trending_up_rounded,
                    color: BizColors.green, size: 13),
                  const SizedBox(width: 4),
                  Text('+18% keçən həftəyə nisbətən', style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: BizColors.green,
                  )),
                ]),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildBar('B.E', 0.6, revVal('84₼')),
              _buildBar('Ç.A', 0.8, revVal('112₼')),
              _buildBar('Çər', 0.5, revVal('70₼')),
              _buildBar('C.A', 0.9, revVal('126₼')),
              _buildBar('Cüm', 0.7, revVal('98₼')),
              _buildBar('Şnb', 1.0, revVal('140₼'), isToday: true),
              _buildBar('Baz', 0.0, revVal('0₼')),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Bu həftə cəmi', style: TextStyle(
                fontSize: 12,
                color: BizColors.textMuted,
              )),
              Text(_showRevenue ? '630 AZN' : '•••', style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: BizColors.forest,
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBar(String day, double height, String amount, {bool isToday = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(amount, style: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.w700,
          color: isToday ? BizColors.sageDark : BizColors.textLight,
        )),
        const SizedBox(height: 4),
        Container(
          width: 28,
          height: height * 80,
          decoration: BoxDecoration(
            color: isToday ? BizColors.forest : BizColors.sageBg,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 6),
        Text(day, style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: isToday ? BizColors.forest : BizColors.textMuted,
        )),
      ],
    );
  }

  Widget _buildDaySelector() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Rezervasiyalar', style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: BizColors.textPrimary,
            letterSpacing: -0.3,
          )),
          Row(
            children: List.generate(_days.length, (i) {
              final selected = _selectedDay == i;
              return GestureDetector(
                onTap: () => setState(() => _selectedDay = i),
                child: Container(
                  margin: const EdgeInsets.only(left: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: selected ? BizColors.forest : BizColors.bgCard,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: selected ? BizColors.shadow : [],
                  ),
                  child: Text(_days[i], style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: selected ? Colors.white : BizColors.textMuted,
                  )),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      itemCount: _bookings.length,
      itemBuilder: (context, i) => _buildBookingCard(_bookings[i], i),
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> b, int index) {
    final status = b['status'] as String;
    final isConfirmed = status == 'confirmed';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: BizColors.bgCard,
        borderRadius: BorderRadius.circular(18),
        boxShadow: BizColors.shadow,
        border: Border.all(
          color: isConfirmed
              ? BizColors.green.withOpacity(0.15)
              : BizColors.amber.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(13),
        child: Row(
          children: [
            SizedBox(
              width: 44,
              child: Column(
                children: [
                  Text(b['time'] as String, style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: BizColors.forest,
                  )),
                  Text(b['duration'] as String, style: TextStyle(
                    fontSize: 9,
                    color: BizColors.textLight,
                    fontWeight: FontWeight.w600,
                  )),
                ],
              ),
            ),
            Container(
              width: 1,
              height: 40,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              color: BizColors.bgMuted,
            ),
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                color: BizColors.sageBg,
                borderRadius: BorderRadius.circular(19),
              ),
              child: Center(child: Text(b['avatar'] as String,
                style: const TextStyle(fontSize: 18))),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(b['name'] as String, style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: BizColors.textPrimary,
                  )),
                  Text(b['service'] as String, style: TextStyle(
                    fontSize: 11,
                    color: BizColors.textMuted,
                  ), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(b['price'] as String, style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: BizColors.forest,
                )),
                const SizedBox(height: 4),
                if (isConfirmed)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: BizColors.green.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text('Təsdiqləndi', style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: BizColors.green,
                    )),
                  )
                else
                  Row(children: [
                    GestureDetector(
                      onTap: () => setState(() {
                        _bookings.removeAt(index);
                      }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: BizColors.red.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text('✕', style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: BizColors.red,
                        )),
                      ),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () => setState(() => b['status'] = 'confirmed'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: BizColors.green.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text('✓', style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: BizColors.green,
                        )),
                      ),
                    ),
                  ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
