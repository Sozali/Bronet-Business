import 'package:flutter/material.dart';
import '../theme/colors.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final List<String> _days = ['B.E', 'Ç.A', 'Çər', 'C.A', 'Cüm', 'Şnb', 'Baz'];
  late List<String> _dates;
  late int _selectedDay;
  late String _monthLabel;

  static const _months = [
    'Yanvar', 'Fevral', 'Mart', 'Aprel', 'May', 'İyun',
    'İyul', 'Avqust', 'Sentyabr', 'Oktyabr', 'Noyabr', 'Dekabr',
  ];

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    final monday = today.subtract(Duration(days: today.weekday - 1));
    _dates = List.generate(7, (i) => '${monday.add(Duration(days: i)).day}');
    _selectedDay = today.weekday - 1; // 0=Mon … 6=Sun
    _monthLabel = '${_months[today.month - 1]} ${today.year}';
  }

  final Map<String, bool> _workingDays = {
    'B.E': true,
    'Ç.A': true,
    'Çər': true,
    'C.A': true,
    'Cüm': true,
    'Şnb': true,
    'Baz': false,
  };

  final Map<String, List<String>> _hours = {
    'B.E': ['09:00', '20:00'],
    'Ç.A': ['09:00', '20:00'],
    'Çər': ['09:00', '20:00'],
    'C.A': ['09:00', '20:00'],
    'Cüm': ['09:00', '21:00'],
    'Şnb': ['10:00', '22:00'],
    'Baz': ['Bağlı', 'Bağlı'],
  };

  final List<Map<String, dynamic>> _slots = [
    {'time': '09:30', 'client': 'Rauf M.', 'service': 'Diş Ağardılması', 'duration': 60, 'status': 'confirmed'},
    {'time': '10:30', 'client': '', 'service': '', 'duration': 30, 'status': 'free'},
    {'time': '11:00', 'client': 'Leyla Ə.', 'service': 'Diş Təmizlənməsi', 'duration': 45, 'status': 'confirmed'},
    {'time': '11:45', 'client': '', 'service': '', 'duration': 30, 'status': 'free'},
    {'time': '12:30', 'client': '', 'service': '', 'duration': 30, 'status': 'break'},
    {'time': '13:00', 'client': 'Tural H.', 'service': 'Breket Məsləhəti', 'duration': 30, 'status': 'pending'},
    {'time': '13:30', 'client': '', 'service': '', 'duration': 30, 'status': 'free'},
    {'time': '14:00', 'client': '', 'service': '', 'duration': 30, 'status': 'free'},
    {'time': '14:30', 'client': 'Nigar Q.', 'service': 'Diş Dolğusu', 'duration': 50, 'status': 'confirmed'},
    {'time': '15:30', 'client': '', 'service': '', 'duration': 30, 'status': 'free'},
    {'time': '16:00', 'client': 'Elşən B.', 'service': 'Rentgen & Müayinə', 'duration': 30, 'status': 'pending'},
    {'time': '16:30', 'client': '', 'service': '', 'duration': 30, 'status': 'free'},
    {'time': '17:00', 'client': '', 'service': '', 'duration': 30, 'status': 'free'},
    {'time': '17:30', 'client': '', 'service': '', 'duration': 30, 'status': 'free'},
    {'time': '18:00', 'client': '', 'service': '', 'duration': 30, 'status': 'free'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BizColors.bgApp,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildWeekStrip(),
            _buildDayStats(),
            Expanded(child: _buildTimeline()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Cədvəl', style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: BizColors.textPrimary,
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
                Icon(Icons.calendar_month_rounded,
                  color: BizColors.forest, size: 14),
                const SizedBox(width: 6),
                Text(_monthLabel, style: TextStyle(
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

  Widget _buildWeekStrip() {
    return Container(
      height: 80,
      margin: const EdgeInsets.fromLTRB(18, 0, 18, 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: BizColors.bgCard,
        borderRadius: BorderRadius.circular(18),
        boxShadow: BizColors.shadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_days.length, (i) {
          final selected = _selectedDay == i;
          final isWorking = _workingDays[_days[i]] ?? false;
          return GestureDetector(
            onTap: () => setState(() => _selectedDay = i),
            child: Container(
              width: 42,
              decoration: BoxDecoration(
                color: selected ? BizColors.forest : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_days[i], style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: selected
                        ? Colors.white.withOpacity(0.7)
                        : BizColors.textLight,
                  )),
                  const SizedBox(height: 4),
                  Text(_dates[i], style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: selected ? Colors.white : BizColors.textPrimary,
                  )),
                  const SizedBox(height: 4),
                  Container(
                    width: 5, height: 5,
                    decoration: BoxDecoration(
                      color: isWorking
                          ? (selected ? Colors.white : BizColors.green)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildDayStats() {
    final day = _days[_selectedDay];
    final isWorking = _workingDays[day] ?? false;
    final hours = _hours[day]!;
    final booked = _slots.where((s) => s['status'] == 'confirmed' || s['status'] == 'pending').length;
    final free = _slots.where((s) => s['status'] == 'free').length;

    return Container(
      margin: const EdgeInsets.fromLTRB(18, 0, 18, 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [BizColors.forest, BizColors.forestDeep],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: BizColors.shadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Container(
              width: 8, height: 8,
              decoration: BoxDecoration(
                color: isWorking ? BizColors.green : BizColors.red,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            Text(isWorking ? '${hours[0]} – ${hours[1]}' : 'İstirahət günü',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              )),
          ]),
          Row(children: [
            _miniStat('$booked', 'Rezerv', BizColors.amber),
            const SizedBox(width: 16),
            _miniStat('$free', 'Boş', BizColors.green),
            const SizedBox(width: 16),
            GestureDetector(
              onTap: () => setState(() => _workingDays[day] = !isWorking),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isWorking
                      ? BizColors.red.withOpacity(0.2)
                      : BizColors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(isWorking ? 'İstirahət' : 'İş günü',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isWorking ? BizColors.red : BizColors.green,
                  )),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _miniStat(String value, String label, Color color) {
    return Column(children: [
      Text(value, style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w900,
        color: color,
      )),
      Text(label, style: TextStyle(
        fontSize: 9,
        color: Colors.white.withOpacity(0.5),
      )),
    ]);
  }

  Widget _buildTimeline() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
      itemCount: _slots.length,
      itemBuilder: (context, i) => _buildSlot(_slots[i]),
    );
  }

  Widget _buildSlot(Map<String, dynamic> slot) {
    final status = slot['status'] as String;
    final isEmpty = status == 'free';
    final isBreak = status == 'break';
    final isPending = status == 'pending';

    Color leftColor;
    if (isBreak) leftColor = BizColors.textLight;
    else if (isPending) leftColor = BizColors.amber;
    else if (isEmpty) leftColor = BizColors.bgMuted;
    else leftColor = BizColors.green;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          // Time
          SizedBox(
            width: 48,
            child: Text(slot['time'] as String, style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isEmpty ? BizColors.textLight : BizColors.textPrimary,
            )),
          ),
          // Color strip
          Container(
            width: 4,
            height: isEmpty ? 40 : 60,
            decoration: BoxDecoration(
              color: leftColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          // Content
          Expanded(
            child: Container(
              padding: EdgeInsets.all(isEmpty ? 10 : 12),
              decoration: BoxDecoration(
                color: isEmpty
                    ? BizColors.bgCard.withOpacity(0.5)
                    : isBreak
                        ? BizColors.bgMuted
                        : BizColors.bgCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isEmpty
                      ? BizColors.bgMuted
                      : isPending
                          ? BizColors.amber.withOpacity(0.3)
                          : Colors.transparent,
                ),
                boxShadow: isEmpty ? [] : BizColors.shadow,
              ),
              child: isEmpty
                  ? Row(children: [
                      Icon(Icons.add_rounded,
                        color: BizColors.textLight, size: 14),
                      const SizedBox(width: 6),
                      Text('Boş slot', style: TextStyle(
                        fontSize: 12,
                        color: BizColors.textLight,
                      )),
                    ])
                  : isBreak
                      ? Row(children: [
                          Icon(Icons.coffee_rounded,
                            color: BizColors.textMuted, size: 14),
                          const SizedBox(width: 6),
                          Text('Fasilə vaxtı', style: TextStyle(
                            fontSize: 12,
                            color: BizColors.textMuted,
                            fontWeight: FontWeight.w600,
                          )),
                        ])
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(slot['client'] as String,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: BizColors.textPrimary,
                                  )),
                                const SizedBox(height: 3),
                                Text(slot['service'] as String,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: BizColors.textMuted,
                                  )),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: leftColor.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    isPending ? 'Gözləyir' : 'Təsdiqləndi',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      color: leftColor,
                                    )),
                                ),
                                const SizedBox(height: 4),
                                Text('${slot['duration']} dəq',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: BizColors.textLight,
                                  )),
                              ],
                            ),
                          ],
                        ),
            ),
          ),
        ],
      ),
    );
  }
}
