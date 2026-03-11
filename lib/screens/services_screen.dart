import 'package:flutter/material.dart';
import '../theme/colors.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  int _selectedCat = 0;
  final List<String> _cats = ['All', 'Haircut', 'Beard', 'Treatment', 'Packages'];

  final List<Map<String, dynamic>> _services = [
    {
      'name': 'Classic Haircut',
      'cat': 'Haircut',
      'duration': '30 min',
      'price': '15',
      'bookings': 142,
      'active': true,
      'icon': Icons.content_cut_rounded,
      'color': 0xFFE8F0E4,
    },
    {
      'name': 'Premium Haircut',
      'cat': 'Haircut',
      'duration': '45 min',
      'price': '25',
      'bookings': 98,
      'active': true,
      'icon': Icons.content_cut_rounded,
      'color': 0xFFE8F0E4,
    },
    {
      'name': 'Kids Haircut',
      'cat': 'Haircut',
      'duration': '20 min',
      'price': '10',
      'bookings': 67,
      'active': true,
      'icon': Icons.child_care_rounded,
      'color': 0xFFFFF0E8,
    },
    {
      'name': 'Beard Trim',
      'cat': 'Beard',
      'duration': '20 min',
      'price': '10',
      'bookings': 89,
      'active': true,
      'icon': Icons.face_rounded,
      'color': 0xFFECF4FC,
    },
    {
      'name': 'Beard Shaping',
      'cat': 'Beard',
      'duration': '30 min',
      'price': '18',
      'bookings': 76,
      'active': true,
      'icon': Icons.face_rounded,
      'color': 0xFFECF4FC,
    },
    {
      'name': 'Hot Towel Shave',
      'cat': 'Beard',
      'duration': '40 min',
      'price': '22',
      'bookings': 45,
      'active': false,
      'icon': Icons.local_fire_department_rounded,
      'color': 0xFFFFF0E8,
    },
    {
      'name': 'Hair Treatment',
      'cat': 'Treatment',
      'duration': '60 min',
      'price': '35',
      'bookings': 34,
      'active': true,
      'icon': Icons.spa_rounded,
      'color': 0xFFEAF4F0,
    },
    {
      'name': 'Scalp Massage',
      'cat': 'Treatment',
      'duration': '30 min',
      'price': '20',
      'bookings': 28,
      'active': true,
      'icon': Icons.self_improvement_rounded,
      'color': 0xFFEAF4F0,
    },
    {
      'name': 'Haircut + Beard',
      'cat': 'Packages',
      'duration': '45 min',
      'price': '30',
      'bookings': 186,
      'active': true,
      'icon': Icons.star_rounded,
      'color': 0xFFF0ECF8,
    },
    {
      'name': 'Full Grooming Package',
      'cat': 'Packages',
      'duration': '90 min',
      'price': '55',
      'bookings': 52,
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
        label: const Text('Add Service', style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
        )),
      ),
    );
  }

  void _showAddServiceSheet() {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    String selectedCat = 'Haircut';
    String selectedDuration = '30 min';

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
              const Text('Add New Service', style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: BizColors.textPrimary,
              )),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Service Name',
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
                  labelText: 'Category',
                  filled: true,
                  fillColor: BizColors.bgSurface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: ['Haircut', 'Beard', 'Treatment', 'Packages']
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
                      labelText: 'Duration',
                      filled: true,
                      fillColor: BizColors.bgSurface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: ['20 min', '30 min', '45 min', '60 min', '90 min']
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
                      labelText: 'Price (AZN)',
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
                      'color': 0xFFE8F0E4,
                    });
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('$name added successfully'),
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
                    child: Text('Add Service', style: TextStyle(
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
            const Text('Services', style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Color(0xFF2C3528),
              letterSpacing: -0.5,
            )),
            Text('${_services.length} services total',
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
          colors: [Color(0xFF2C3528), Color(0xFF1E2A1A)],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: BizColors.shadowStrong,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statItem('$active', 'Active', BizColors.green),
          Container(width: 1, height: 30, color: Colors.white.withOpacity(0.1)),
          _statItem('$inactive', 'Inactive', BizColors.red),
          Container(width: 1, height: 30, color: Colors.white.withOpacity(0.1)),
          _statItem('$totalBookings', 'Total Bookings', Colors.white),
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
                    Text('${s['bookings']} bookings', style: TextStyle(
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
                  onTap: () => setState(() => s['active'] = !active),
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
