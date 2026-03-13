import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'subscription_screen.dart';

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

  String _bizName = BizAuthService.businessName;
  String _bizAddress = 'İstiqlaliyyət küç. 12, Bakı';
  String _bizPhone = '+994 12 498 76 54';

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('$feature — Tezliklə!'),
      backgroundColor: BizColors.sageDark,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  void _showEditSheet(String title, String currentValue, ValueChanged<String> onSave) {
    final ctrl = TextEditingController(text: currentValue);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0,
            MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: BizColors.bgMuted,
                  borderRadius: BorderRadius.circular(2),
                ),
              )),
              const SizedBox(height: 20),
              Text('$title redaktə et', style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w900,
                color: BizColors.textPrimary)),
              const SizedBox(height: 16),
              TextField(
                controller: ctrl,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: title,
                  filled: true,
                  fillColor: BizColors.bgSurface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    onSave(ctrl.text.trim());
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('$title yeniləndi!'),
                      backgroundColor: BizColors.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BizColors.forest,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Dəyişiklikləri Saxla', style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w800)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
              _buildSectionLabel('Biznes Məlumatları'),
              _buildMenuItem(Icons.store_rounded, 'Biznesin Adı', _bizName,
                  () => _showEditSheet('Biznesin Adı', _bizName, (v) => setState(() => _bizName = v))),
              _buildMenuItem(Icons.location_on_rounded, 'Ünvan', _bizAddress,
                  () => _showEditSheet('Ünvan', _bizAddress, (v) => setState(() => _bizAddress = v))),
              _buildMenuItem(Icons.phone_rounded, 'Telefon', _bizPhone,
                  () => _showEditSheet('Telefon', _bizPhone, (v) => setState(() => _bizPhone = v))),
              _buildMenuItem(Icons.language_rounded, 'Kateqoriya', 'Diş Klinikası',
                  () => _showComingSoon('Kateqoriya Redaktəsi')),
              _buildMenuItem(Icons.photo_library_rounded, 'Şəkillər & Qalereya', '12 şəkil',
                  () => _showComingSoon('Foto Qalereyası')),
              _buildSectionLabel('Rezervasiya Ayarları'),
              _buildToggleItem(Icons.book_online_rounded, 'Onlayn Rezervasiya', 'Tətbiq vasitəsilə rezerv qəbul et', _onlineBooking, (v) => setState(() => _onlineBooking = v)),
              _buildToggleItem(Icons.check_circle_rounded, 'Avtomatik Təsdiq', 'Rezervasiyaları avtomatik təsdiqlə', _autoConfirm, (v) => setState(() => _autoConfirm = v)),
              _buildMenuItem(Icons.timelapse_rounded, 'Rezervasiya Pəncərəsi', '30 gün əvvəl',
                  () => _showComingSoon('Rezervasiya Pəncərəsi')),
              _buildMenuItem(Icons.cancel_rounded, 'Ləğvetmə Qaydası', '2 saat bildiriş',
                  () => _showComingSoon('Ləğvetmə Qaydası')),
              _buildSectionLabel('Bildirişlər'),
              _buildToggleItem(Icons.notifications_rounded, 'Push Bildirişlər', 'Yeni rezervlər & xatırlatmalar', _notifications, (v) => setState(() => _notifications = v)),
              _buildToggleItem(Icons.local_offer_rounded, 'Promosyonlar', 'Endirim & təklif bildirişləri', _promotions, (v) => setState(() => _promotions = v)),
              _buildSectionLabel('Hesab'),
              _buildMenuItem(Icons.workspace_premium_rounded, 'Abunəlik Planı', 'Gümüş Plan · 9.99 AZN/ay',
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BizSubscriptionScreen()))),
              _buildMenuItem(Icons.payments_rounded, 'Ödəniş Ayarları', 'Bank: ABB •• 4242',
                  () => _showComingSoon('Ödəniş Ayarları')),
              _buildMenuItem(Icons.bar_chart_rounded, 'Analitika', 'Tam hesabatlara bax',
                  () => _showComingSoon('Analitika')),
              _buildMenuItem(Icons.help_outline_rounded, 'Yardım & Dəstək', 'FAQ & bizimlə əlaqə',
                  () => _showComingSoon('Yardım Mərkəzi')),
              _buildMenuItem(Icons.star_outline_rounded, 'Tətbiqi Qiymətləndir', 'Bronet Businessi sevirsiniz?',
                  () => _showComingSoon('Tətbiqi Qiymətləndir')),
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
          colors: [BizColors.forest, BizColors.forestDeep],
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
                  border: Border.all(color: BizColors.forest, width: 2),
                ),
                child: const Center(
                  child: Icon(Icons.edit_rounded,
                    size: 10, color: Colors.white),
                ),
              ),
            ),
          ]),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('SmilePro Dental', style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                )),
                const SizedBox(height: 3),
                Text(_bizAddress, style: TextStyle(
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
                      Text('İndi Açıq', style: TextStyle(
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
                    child: Text('Doğrulanmış ✓', style: TextStyle(
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
      {'value': '318', 'label': 'Rəylər'},
      {'value': '4.9', 'label': 'Reytinq'},
      {'value': '1.2K', 'label': 'Rezervlər'},
      {'value': '98%', 'label': 'Təsdiq Nisbəti'},
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
              Text('Müştəri Rəyləri', style: TextStyle(
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
      child: GestureDetector(
        onTap: () => showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text('Çıxış', style: TextStyle(
              fontWeight: FontWeight.w800, color: BizColors.textPrimary)),
            content: const Text('Çıxmaq istədiyinizə əminsiniz?',
              style: TextStyle(fontSize: 14, color: BizColors.textMuted)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Ləğv et',
                  style: TextStyle(color: BizColors.textMuted)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  BizAuthService.logout();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const BizLoginScreen()),
                    (_) => false,
                  );
                },
                child: const Text('Çıxış',
                  style: TextStyle(
                    color: Color(0xFFFF4D6A), fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
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
              Text('Çıxış', style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: BizColors.red,
              )),
            ],
          ),
        ),
      ),
    );
  }
}
