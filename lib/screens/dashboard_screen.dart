import 'package:flutter/material.dart';
import '../theme/colors.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedDay = 0;
  final List<String> _days = ['Today', 'Tomorrow', 'This Week'];

  final List<Map<String, dynamic>> _bookings = [
    {
      'name': 'Rauf Məmmədov',
      'service': 'Classic Haircut + Beard',
      'time': '10:00',
      'duration': '45 min',
      'price': '25 AZN',
      'status': 'confirmed',
      'avatar': '👨',
    },
    {
      'name': 'Leyla Əliyeva',
      'service': 'Hair Coloring',
      'time': '11:30',
      'duration': '90 min',
      'price': '65 AZN',
      'status': 'confirmed',
      'avatar': '👩',
    },
    {
      'name': 'Tural Hüseynov',
      'service': 'Classic Haircut',
      'time': '13:00',
      'duration': '30 min',
      'price': '15 AZN',
      'status': 'pending',
      'avatar': '👨',
    },
    {
      'name': 'Nigar Quliyeva',
      'service': 'Beard Trim',
      'time': '14:30',
      'duration': '20 min',
      'price': '10 AZN',
      'status': 'confirmed',
      'avatar': '👩',
    },
    {
      'name': 'Elşən Babayev',
      'service': 'Classic Haircut + Beard',
      'time': '16:00',
      'duration': '45 min',
      'price': '25 AZN',
      'status': 'pending',
      'avatar': '👨',
    },
  ];

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
          colors: [Color(0xFF2C3528), Color(0xFF1E2A1A)],
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
                  color: Color(0xFFA8B6A1),
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
            Text('Qehreman Barbershop',
              style: TextStyle(
                color: Colors.white.withOpacity(0.55),
                fontSize: 12,
              )),
          ]),
          Row(children: [
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
            const SizedBox(width: 8),
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                color: BizColors.sage.withOpacity(0.25),
                borderRadius: BorderRadius.circular(19),
              ),
              child: const Center(
                child: Text('✂️', style: TextStyle(fontSize: 18)),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    final stats = [
      {'label': 'Today', 'value': '5', 'sub': 'bookings', 'icon': Icons.calendar_today_rounded, 'color': 0xFF4A90D9},
      {'label': 'Revenue', 'value': '140₼', 'sub': 'today', 'icon': Icons.payments_rounded, 'color': 0xFF3DAD7F},
      {'label': 'Pending', 'value': '2', 'sub': 'to confirm', 'icon': Icons.pending_rounded, 'color': 0xFFFFB830},
      {'label': 'Rating', 'value': '4.9', 'sub': '318 reviews', 'icon': Icons.star_rounded, 'color': 0xFFFF4D6A},
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.2,
        children: stats.map((s) {
          final color = Color(s['color'] as int);
          return Container(
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
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(s['value'] as String, style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: BizColors.forest,
                  )),
                  Text(s['sub'] as String, style: TextStyle(
                    fontSize: 9,
                    color: BizColors.textMuted,
                    fontWeight: FontWeight.w600,
                  )),
                ],
              ),
            ]),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRevenueCard() {
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
              Text('Weekly Revenue', style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: BizColors.forest,
              )),
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
                  Text('+18% vs last week', style: TextStyle(
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
              _buildBar('Mon', 0.6, '84₼'),
              _buildBar('Tue', 0.8, '112₼'),
              _buildBar('Wed', 0.5, '70₼'),
              _buildBar('Thu', 0.9, '126₼'),
              _buildBar('Fri', 0.7, '98₼'),
              _buildBar('Sat', 1.0, '140₼', isToday: true),
              _buildBar('Sun', 0.0, '0₼'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('This week total', style: TextStyle(
                fontSize: 12,
                color: BizColors.textMuted,
              )),
              Text('630 AZN', style: TextStyle(
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
          const Text('Bookings', style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: Color(0xFF2C3528),
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
            // Time column
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
            // Avatar
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
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(b['name'] as String, style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2C3528),
                  )),
                  Text(b['service'] as String, style: TextStyle(
                    fontSize: 11,
                    color: BizColors.textMuted,
                  ), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            // Right side
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
                    child: Text('Confirmed', style: TextStyle(
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
