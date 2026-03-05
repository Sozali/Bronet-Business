import 'package:flutter/material.dart';
import '../theme/colors.dart';

class BusinessProfileScreen extends StatefulWidget {
  const BusinessProfileScreen({super.key});

  @override
  State<BusinessProfileScreen> createState() => _BusinessProfileScreenState();
}

class _BusinessProfileScreenState extends State<BusinessProfileScreen> {
  bool _onlineBooking = true;
  bool _autoConfirm = false;
  bool _notifications = true;
  bool _promotions = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BizColors.bgApp,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              _buildStatsRow(),
              _buildRatingCard(),
              _buildSectionLabel('Business Info'),
              _buildMenuItem(Icons.store_rounded, 'Business Name', 'Qehreman Barbershop', () {}),
              _buildMenuItem(Icons.location_on_rounded, 'Address', 'Nizami St. 45, Baku', () {}),
              _buildMenuItem(Icons.phone_rounded, 'Phone', '+994 50 123 45 67', () {}),
              _buildMenuItem(Icons.language_rounded, 'Category', 'Barbershop', () {}),
              _buildMenuItem(Icons.photo_library_rounded, 'Photos & Gallery', '12 photos', () {}),
              _buildSectionLabel('Booking Settings'),
              _buildToggleItem(Icons.book_online_rounded, 'Online Booking', 'Accept bookings via app', _onlineBooking, (v) => setState(() => _onlineBooking = v)),
              _buildToggleItem(Icons.check_circle_rounded, 'Auto Confirm', 'Confirm bookings automatically', _autoConfirm, (v) => setState(() => _autoConfirm = v)),
              _buildMenuItem(Icons.timelapse_rounded, 'Booking Window', '30 days ahead', () {}),
              _buildMenuItem(Icons.cancel_rounded, 'Cancellation Policy', '2 hours notice', () {}),
              _buildSectionLabel('Notifications'),
              _buildToggleItem(Icons.notifications_rounded, 'Push Notifications', 'New bookings & reminders', _notifications, (v) => setState(() => _notifications = v)),
              _buildToggleItem(Icons.local_offer_rounded, 'Promotions', 'Deal & offer alerts', _promotions, (v) => setState(() => _promotions = v)),
              _buildSectionLabel('Account'),
              _buildMenuItem(Icons.payments_rounded, 'Payout Settings', 'Bank: ABB •• 4242', () {}),
              _buildMenuItem(Icons.bar_chart_rounded, 'Analytics', 'View full reports', () {}),
              _buildMenuItem(Icons.help_outline_rounded, 'Help & Support', 'FAQ & contact us', () {}),
              _buildMenuItem(Icons.star_outline_rounded, 'Rate the App', 'Love Bronet Business?', () {}),
              const SizedBox(height: 8),
              _buildLogoutButton(),
              const SizedBox(height: 24),
              Text("BRON'ET Business v1.0.0", style: TextStyle(
                fontSize: 11,
                color: BizColors.textLight,
              )),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2C3528), Color(0xFF1E2A1A)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: BizColors.shadowStrong,
      ),
      child: Row(
        children: [
          Stack(children: [
            Container(
              width: 68, height: 68,
              decoration: BoxDecoration(
                color: BizColors.sage.withOpacity(0.25),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: BizColors.sage.withOpacity(0.4),
                  width: 2,
                ),
              ),
              child: const Center(
                child: Icon(Icons.content_cut_rounded, color: Colors.white, size: 30),
              ),
            ),
            Positioned(
              bottom: 0, right: 0,
              child: Container(
                width: 22, height: 22,
                decoration: BoxDecoration(
                  color: BizColors.sage,
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(color: const Color(0xFF2C3528), width: 2),
                ),
                child: const Center(
                  child: Icon(Icons.edit_rounded,
                    size: 10, color: Color(0xFF2C3528)),
                ),
              ),
            ),
          ]),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Qehreman Barbershop', style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                )),
                const SizedBox(height: 3),
                Text('Nizami St. 45, Baku', style: TextStyle(
                  color: Colors.white.withOpacity(0.55),
                  fontSize: 12,
                )),
                const SizedBox(height: 8),
                Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: BizColors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: BizColors.green.withOpacity(0.35)),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Container(
                        width: 6, height: 6,
                        decoration: BoxDecoration(
                          color: BizColors.green,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text('Open Now', style: TextStyle(
                        color: BizColors.green,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      )),
                    ]),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: BizColors.sage.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('Verified ✓', style: TextStyle(
                      color: BizColors.sage,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    )),
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    final stats = [
      {'value': '318', 'label': 'Reviews'},
      {'value': '4.9', 'label': 'Rating'},
      {'value': '1.2K', 'label': 'Bookings'},
      {'value': '98%', 'label': 'Confirm Rate'},
    ];
    return Container(
      margin: const EdgeInsets.fromLTRB(18, 0, 18, 16),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: BizColors.bgCard,
        borderRadius: BorderRadius.circular(20),
        boxShadow: BizColors.shadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: stats.map((s) => Column(children: [
          Text(s['value']!, style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: BizColors.forest,
          )),
          const SizedBox(height: 3),
          Text(s['label']!, style: TextStyle(
            fontSize: 10,
            color: BizColors.textMuted,
            fontWeight: FontWeight.w600,
          )),
        ])).toList(),
      ),
    );
  }

  Widget _buildRatingCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(18, 0, 18, 20),
      padding: const EdgeInsets.all(16),
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
              Text('Customer Reviews', style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: BizColors.forest,
              )),
              Row(children: [
                const Icon(Icons.star_rounded,
                  color: Color(0xFFFFB830), size: 16),
                const SizedBox(width: 4),
                Text('4.9', style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: BizColors.forest,
                )),
              ]),
            ],
          ),
          const SizedBox(height: 12),
          _ratingBar('5 ⭐', 0.82),
          _ratingBar('4 ⭐', 0.12),
          _ratingBar('3 ⭐', 0.04),
          _ratingBar('2 ⭐', 0.01),
          _ratingBar('1 ⭐', 0.01),
        ],
      ),
    );
  }

  Widget _ratingBar(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(children: [
        SizedBox(
          width: 40,
          child: Text(label, style: TextStyle(
            fontSize: 11,
            color: BizColors.textMuted,
          )),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 7,
              backgroundColor: BizColors.bgMuted,
              valueColor: AlwaysStoppedAnimation<Color>(BizColors.sage),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 32,
          child: Text('${(value * 100).toInt()}%',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: BizColors.textMuted,
            ), textAlign: TextAlign.right),
        ),
      ]),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
      child: Text(label.toUpperCase(), style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w800,
        color: BizColors.textLight,
        letterSpacing: 1.5,
      )),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(18, 0, 18, 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(
          color: BizColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          boxShadow: BizColors.shadow,
        ),
        child: Row(children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
              color: BizColors.forest.withOpacity(0.08),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Center(
              child: Icon(icon, color: BizColors.forest, size: 18),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: BizColors.textPrimary,
                )),
                Text(subtitle, style: TextStyle(
                  fontSize: 11,
                  color: BizColors.textMuted,
                )),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded,
            color: BizColors.textLight, size: 20),
        ]),
      ),
    );
  }

  Widget _buildToggleItem(
    IconData icon,
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.fromLTRB(18, 0, 18, 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: BizColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        boxShadow: BizColors.shadow,
      ),
      child: Row(children: [
        Container(
          width: 38, height: 38,
          decoration: BoxDecoration(
            color: BizColors.forest.withOpacity(0.08),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Center(
            child: Icon(icon, color: BizColors.forest, size: 18),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: BizColors.textPrimary,
              )),
              Text(subtitle, style: TextStyle(
                fontSize: 11,
                color: BizColors.textMuted,
              )),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: BizColors.sage,
          activeTrackColor: BizColors.sage.withOpacity(0.3),
          inactiveThumbColor: BizColors.textLight,
          inactiveTrackColor: BizColors.bgMuted,
        ),
      ]),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      margin: const EdgeInsets.fromLTRB(18, 0, 18, 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: BizColors.red.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: BizColors.red.withOpacity(0.20)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, color: BizColors.red, size: 18),
            const SizedBox(width: 8),
            Text('Log Out', style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: BizColors.red,
            )),
          ],
        ),
      ),
    );
  }
}
