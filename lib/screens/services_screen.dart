import 'package:flutter/material.dart';
import '../theme/colors.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  int _selectedCat = 0;
  final List<String> _cats = ['Hamısı', 'Təmizlik', 'Ağardma', 'Ortodontiya', 'Paketlər'];

  final List<Map<String, dynamic>> _services = [
    {
      'name': 'Diş Təmizlənməsi',
      'cat': 'Təmizlik',
      'duration': '45 dəq',
      'price': '55',
      'bookings': 218,
      'active': true,
      'icon': Icons.clean_hands_rounded,
      'color': 0xFFE6F0FA,
    },
    {
      'name': 'Dərin Təmizlənmə',
      'cat': 'Təmizlik',
      'duration': '60 dəq',
      'price': '90',
      'bookings': 104,
      'active': true,
      'icon': Icons.sanitizer_rounded,
      'color': 0xFFE6F0FA,
    },
    {
      'name': 'Diş Dolğusu',
      'cat': 'Təmizlik',
      'duration': '50 dəq',
      'price': '80',
      'bookings': 87,
      'active': true,
      'icon': Icons.medical_services_rounded,
      'color': 0xFFFFF0E8,
    },
    {
      'name': 'Diş Ağardılması',
      'cat': 'Ağardma',
      'duration': '60 dəq',
      'price': '120',
      'bookings': 165,
      'active': true,
      'icon': Icons.auto_awesome_rounded,
      'color': 0xFFECF4FC,
    },
    {
      'name': 'Lazer Ağardması',
      'cat': 'Ağardma',
      'duration': '90 dəq',
      'price': '200',
      'bookings': 72,
      'active': true,
      'icon': Icons.flash_on_rounded,
      'color': 0xFFECF4FC,
    },
    {
      'name': 'Evdə Ağartma Dəsti',
      'cat': 'Ağardma',
      'duration': '20 dəq',
      'price': '65',
      'bookings': 49,
      'active': false,
      'icon': Icons.home_rounded,
      'color': 0xFFFFF0E8,
    },
    {
      'name': 'Breket Məsləhəti',
      'cat': 'Ortodontiya',
      'duration': '30 dəq',
      'price': '40',
      'bookings': 56,
      'active': true,
      'icon': Icons.psychology_rounded,
      'color': 0xFFE8F3FC,
    },
    {
      'name': 'Rentgen & Müayinə',
      'cat': 'Ortodontiya',
      'duration': '30 dəq',
      'price': '35',
      'bookings': 143,
      'active': true,
      'icon': Icons.biotech_rounded,
      'color': 0xFFE8F3FC,
    },
    {
      'name': 'Təmizlənmə + Ağardma',
      'cat': 'Paketlər',
      'duration': '90 dəq',
      'price': '150',
      'bookings': 211,
      'active': true,
      'icon': Icons.star_rounded,
      'color': 0xFFF0ECF8,
    },
    {
      'name': 'Tam Diş Müayinəsi',
      'cat': 'Paketlər',
      'duration': '90 dəq',
      'price': '120',
      'bookings': 78,
      'active': true,
      'icon': Icons.workspace_premium_rounded,
      'color': 0xFFF0ECF8,
    },
  ];

  List<Map<String, dynamic>> get _filtered {
    if (_selectedCat == 0) return _services;
    return _services.where((s) => s['cat'] == _cats[_selectedCat]).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BizColors.bgApp,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildStatsRow(),
            _buildCategoryTabs(),
            Expanded(child: _buildServicesList()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddServiceSheet,
        backgroundColor: BizColors.forest,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Xidmət Əlavə Et', style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
        )),
      ),
    );
  }

  void _showAddServiceSheet() {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    String selectedCat = 'Təmizlik';
    String selectedDuration = '30 dəq';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.fromLTRB(24, 20, 24,
              MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: BizColors.bgMuted,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Yeni Xidmət Əlavə Et', style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: BizColors.textPrimary,
              )),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Xidmətin Adı',
                  filled: true,
                  fillColor: BizColors.bgSurface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedCat,
                decoration: InputDecoration(
                  labelText: 'Kateqoriya',
                  filled: true,
                  fillColor: BizColors.bgSurface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: ['Təmizlik', 'Ağardma', 'Ortodontiya', 'Paketlər']
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setModalState(() => selectedCat = v!),
              ),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedDuration,
                    decoration: InputDecoration(
                      labelText: 'Müddət',
                      filled: true,
                      fillColor: BizColors.bgSurface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: ['20 dəq', '30 dəq', '45 dəq', '60 dəq', '90 dəq']
                        .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                        .toList(),
                    onChanged: (v) => setModalState(() => selectedDuration = v!),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Qiymət (AZN)',
                      filled: true,
                      fillColor: BizColors.bgSurface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ]),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  final name = nameController.text.trim();
                  final price = priceController.text.trim();
                  if (name.isEmpty || price.isEmpty) return;
                  Navigator.pop(ctx);
                  setState(() {
                    _services.add({
                      'name': name,
                      'cat': selectedCat,
                      'duration': selectedDuration,
                      'price': price,
                      'bookings': 0,
                      'active': true,
                      'icon': Icons.miscellaneous_services_rounded,
                      'color': 0xFFE6F0FA,
                    });
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('$name uğurla əlavə edildi'),
                    backgroundColor: BizColors.green,
                    behavior: SnackBarBehavior.floating,
                  ));
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: BizColors.forest,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text('Xidmət Əlavə Et', style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    )),
                  ),
                ),
              ),
            ],
          ),
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
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Xidmətlər', style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: BizColors.textPrimary,
              letterSpacing: -0.5,
            )),
            Text('Cəmi ${_services.length} xidmət',
              style: TextStyle(
                fontSize: 12,
                color: BizColors.textMuted,
              )),
          ]),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: BizColors.bgCard,
              borderRadius: BorderRadius.circular(12),
              boxShadow: BizColors.shadow,
            ),
            child: Icon(Icons.search_rounded,
              color: BizColors.forest, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    final active = _services.where((s) => s['active'] == true).length;
    final inactive = _services.where((s) => s['active'] == false).length;
    final totalBookings = _services.fold(0, (sum, s) => sum + (s['bookings'] as int));

    return Container(
      margin: const EdgeInsets.fromLTRB(18, 0, 18, 14),
      padding: const EdgeInsets.all(16),
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
          _statItem('$active', 'Aktiv', BizColors.green),
          Container(width: 1, height: 30, color: Colors.white.withOpacity(0.1)),
          _statItem('$inactive', 'Deaktiv', BizColors.red),
          Container(width: 1, height: 30, color: Colors.white.withOpacity(0.1)),
          _statItem('$totalBookings', 'Cəmi Rezerv', Colors.white),
        ],
      ),
    );
  }

  Widget _statItem(String value, String label, Color color) {
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

  Widget _buildCategoryTabs() {
    return SizedBox(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: _cats.length,
        itemBuilder: (context, i) {
          final selected = _selectedCat == i;
          return GestureDetector(
            onTap: () => setState(() => _selectedCat = i),
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
              child: Text(_cats[i], style: TextStyle(
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

  Widget _buildServicesList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 100),
      itemCount: _filtered.length,
      itemBuilder: (context, i) => _buildServiceCard(_filtered[i]),
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> s) {
    final active = s['active'] as bool;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: BizColors.bgCard,
        borderRadius: BorderRadius.circular(18),
        boxShadow: BizColors.shadow,
        border: Border.all(
          color: active
              ? Colors.transparent
              : BizColors.red.withOpacity(0.15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 50, height: 50,
              decoration: BoxDecoration(
                color: active
                    ? Color(s['color'] as int)
                    : BizColors.bgMuted,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Icon(
                  s['icon'] as IconData,
                  color: active ? BizColors.forest : BizColors.textLight,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s['name'] as String, style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: active
                        ? BizColors.textPrimary
                        : BizColors.textLight,
                  )),
                  const SizedBox(height: 4),
                  Row(children: [
                    Icon(Icons.access_time_rounded,
                      size: 11, color: BizColors.textLight),
                    const SizedBox(width: 3),
                    Text(s['duration'] as String, style: TextStyle(
                      fontSize: 11,
                      color: BizColors.textMuted,
                    )),
                    const SizedBox(width: 10),
                    Icon(Icons.bookmark_rounded,
                      size: 11, color: BizColors.textLight),
                    const SizedBox(width: 3),
                    Text('${s['bookings']} rezerv', style: TextStyle(
                      fontSize: 11,
                      color: BizColors.textMuted,
                    )),
                  ]),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${s['price']} AZN', style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: active ? BizColors.forest : BizColors.textLight,
                )),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () {
                    setState(() => s['active'] = !active);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(active
                          ? '${s['name']} dayandırıldı'
                          : '${s['name']} aktivləşdirildi'),
                      backgroundColor: active ? BizColors.red : BizColors.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ));
                  },
                  child: Container(
                    width: 44,
                    height: 24,
                    decoration: BoxDecoration(
                      color: active ? BizColors.green : BizColors.bgMuted,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: AnimatedAlign(
                      duration: const Duration(milliseconds: 200),
                      alignment: active
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        width: 20,
                        height: 20,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: BizColors.shadow,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
