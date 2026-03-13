import 'package:flutter/material.dart';
import '../theme/colors.dart';

class BizSubscriptionScreen extends StatefulWidget {
  const BizSubscriptionScreen({super.key});

  @override
  State<BizSubscriptionScreen> createState() => _BizSubscriptionScreenState();
}

class _BizSubscriptionScreenState extends State<BizSubscriptionScreen> {
  int _currentPlan = 0; // 0=Silver, 1=Gold, 2=Premium

  final List<Map<String, dynamic>> _plans = [
    {
      'name': 'Silver',
      'price': '9.99 AZN',
      'priceNum': 9.99,
      'color': 0xFF6B7280,
      'accentColor': 0xFFD1D5DB,
      'emoji': '🥈',
      'features': [
        'Ayda 50-ə qədər rezervasiya',
        'Əsas analitika paneli',
        'Standart siyahı yerləşdirməsi',
        'E-poçt dəstəyi',
      ],
    },
    {
      'name': 'Gold',
      'price': '19.99 AZN',
      'priceNum': 19.99,
      'color': 0xFFD48A00,
      'accentColor': 0xFFFFB830,
      'emoji': '🥇',
      'features': [
        'Limitsiz rezervasiya',
        'Ətraflı analitika',
        'Prioritet siyahı (axtarışda yuxarı)',
        'Tanıtım endirimlər xüsusiyyəti',
        'Reytinq yüksəltmə alətləri',
      ],
    },
    {
      'name': 'Premium',
      'price': '29.99 AZN',
      'priceNum': 29.99,
      'color': 0xFF7C3AED,
      'accentColor': 0xFFDDD6FE,
      'emoji': '💎',
      'features': [
        'Siyahının başında (Tövsiyə edilir)',
        'Avtomatik rezerv təsdiqi',
        'Müştəri saxlama AI məsləhətləri',
        'Şəxsi hesab meneceri',
        'Fərdi rezerv səhifəsi dizaynı',
        'Bütün axtarışlarda prioritet artım',
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BizColors.bgApp,
      appBar: AppBar(
        backgroundColor: BizColors.forest,
        foregroundColor: Colors.white,
        title: const Text('Abunəlik Planları', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [BizColors.forest, BizColors.forestDeep]),
              borderRadius: BorderRadius.circular(20),
              boxShadow: BizColors.shadow,
            ),
            child: Column(children: [
              const Text('Biznes Planları', style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
              const SizedBox(height: 6),
              Text('Daha çox görünürlüklə biznesinizi böyüdün',
                style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.7))),
            ]),
          ),
          const SizedBox(height: 20),

          ..._plans.asMap().entries.map((entry) {
            final i = entry.key;
            final plan = entry.value;
            final isCurrent = _currentPlan == i;
            final color = Color(plan['color'] as int);
            final accentColor = Color(plan['accentColor'] as int);
            final features = plan['features'] as List<String>;

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: BizColors.bgCard,
                borderRadius: BorderRadius.circular(20),
                boxShadow: BizColors.shadow,
                border: isCurrent
                    ? Border.all(color: color, width: 2.5)
                    : Border.all(color: BizColors.bgMuted, width: 1),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.15),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Row(children: [
                    Text(plan['emoji'] as String, style: const TextStyle(fontSize: 32)),
                    const SizedBox(width: 14),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Text(plan['name'] as String, style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w900, color: color)),
                        if (isCurrent) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: BizColors.green.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(mainAxisSize: MainAxisSize.min, children: [
                              Icon(Icons.check_circle_rounded, size: 10, color: BizColors.green),
                              const SizedBox(width: 3),
                              Text('Cari Plan', style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w700, color: BizColors.green)),
                            ]),
                          ),
                        ],
                      ]),
                      const SizedBox(height: 2),
                      RichText(text: TextSpan(children: [
                        TextSpan(text: plan['price'] as String, style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w900, color: color)),
                        TextSpan(text: '/ay', style: TextStyle(
                          fontSize: 11, color: BizColors.textMuted)),
                      ])),
                    ])),
                  ]),
                ),

                Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...features.map((f) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(children: [
                          Icon(Icons.check_rounded, size: 16, color: color),
                          const SizedBox(width: 10),
                          Expanded(child: Text(f, style: const TextStyle(
                            fontSize: 13, color: BizColors.textPrimary))),
                        ]),
                      )).toList(),
                      const SizedBox(height: 10),
                      if (!isCurrent)
                        SizedBox(width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() => _currentPlan = i);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('${plan['name']} planına abunə oldunuz!'),
                                backgroundColor: BizColors.forest,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: color,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            child: Text(
                              _currentPlan > i ? '${plan['name']} planına keç' : '${plan['name']} planına yüksəlt',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
                          ),
                        )
                      else
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: BizColors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: BizColors.green.withOpacity(0.3)),
                          ),
                          child: Center(child: Row(mainAxisSize: MainAxisSize.min, children: [
                            Icon(Icons.check_circle_rounded, size: 16, color: BizColors.green),
                            const SizedBox(width: 6),
                            Text('Aktiv Plan', style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w800, color: BizColors.green)),
                          ])),
                        ),
                    ],
                  ),
                ),
              ]),
            );
          }).toList(),

          const SizedBox(height: 10),
          Text('Aylıq ödəniş · İstənilən vaxt ləğv edin',
            style: TextStyle(fontSize: 12, color: BizColors.textLight)),
          const SizedBox(height: 24),
        ]),
      ),
    );
  }
}
