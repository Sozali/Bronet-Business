import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../theme/colors.dart';

class BizLoginScreen extends StatefulWidget {
  const BizLoginScreen({super.key});

  @override
  State<BizLoginScreen> createState() => _BizLoginScreenState();
}

class _BizLoginScreenState extends State<BizLoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _savePassword = false;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() { _loading = true; _error = null; });
    await Future.delayed(const Duration(milliseconds: 350));
    final ok = BizAuthService.login(_emailCtrl.text, _passCtrl.text);
    if (!mounted) return;
    if (ok) {
      Navigator.pushReplacementNamed(context, '/root');
    } else {
      setState(() {
        _loading = false;
        _error = 'Yanlış məlumatlar. Sınayın: admin@smilepro.az / SmilePro123';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BizColors.bgApp,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Biznes Girişi', style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w900,
                    color: BizColors.textPrimary,
                  )),
                  const SizedBox(height: 4),
                  Text('Rezervasiya və xidmətləri idarə etmək üçün daxil olun', style: TextStyle(
                    fontSize: 14, color: BizColors.textMuted,
                  )),
                  const SizedBox(height: 28),

                  _buildLabel('Biznes E-poçtu'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color: BizColors.textPrimary, fontSize: 15),
                    decoration: _inputDecoration(
                      hint: 'admin@smilepro.az',
                      icon: Icons.email_outlined,
                    ),
                  ),
                  const SizedBox(height: 18),

                  _buildLabel('Şifrə'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _passCtrl,
                    obscureText: _obscure,
                    style: TextStyle(color: BizColors.textPrimary, fontSize: 15),
                    decoration: _inputDecoration(
                      hint: 'Şifrənizi daxil edin',
                      icon: Icons.lock_outline_rounded,
                      suffix: IconButton(
                        icon: Icon(
                          _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          color: BizColors.textLight, size: 20,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      SizedBox(
                        width: 20, height: 20,
                        child: Checkbox(
                          value: _savePassword,
                          activeColor: BizColors.forest,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          onChanged: (v) => setState(() => _savePassword = v ?? false),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('Şifrəni yadda saxla', style: TextStyle(
                        fontSize: 13, color: BizColors.textMuted,
                      )),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        child: Text('Unutdunuz?', style: TextStyle(
                          fontSize: 13, color: BizColors.forest,
                          fontWeight: FontWeight.w600,
                        )),
                      ),
                    ],
                  ),

                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: BizColors.red.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: BizColors.red.withOpacity(0.2)),
                      ),
                      child: Row(children: [
                        Icon(Icons.error_outline_rounded, color: BizColors.red, size: 16),
                        const SizedBox(width: 8),
                        Expanded(child: Text(_error!, style: TextStyle(
                          color: BizColors.red, fontSize: 12,
                        ))),
                      ]),
                    ),
                  ],

                  const SizedBox(height: 28),

                  SizedBox(
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: _loading ? null : _login,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [BizColors.forest, BizColors.forestDeep],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: BizColors.shadowStrong,
                        ),
                        child: Center(
                          child: _loading
                              ? const SizedBox(
                                  width: 22, height: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2.5))
                              : const Text('Daxil Ol', style: TextStyle(
                                  color: Colors.white, fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                )),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  Center(
                    child: Text(
                      'Biznes hesabları administratorlar tərəfindən yaradılır.\nGiriş üçün dəstəklə əlaqə saxlayın.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: BizColors.textLight, fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 36),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [BizColors.forest, BizColors.forestDeep],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              width: 42, height: 42,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text('🦷', style: TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(width: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              RichText(text: const TextSpan(
                children: [
                  TextSpan(text: "BRON", style: TextStyle(
                    color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900,
                  )),
                  TextSpan(text: "'ET", style: TextStyle(
                    color: Colors.white70, fontSize: 18, fontWeight: FontWeight.w400,
                  )),
                  TextSpan(text: " Business", style: TextStyle(
                    color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w400,
                  )),
                ],
              )),
            ]),
          ]),
          const SizedBox(height: 20),
          const Text('Biznes Portalı', style: TextStyle(
            color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900,
          )),
          const SizedBox(height: 6),
          Text('Rezervasiyalar, xidmətlər və cədvəli idarə edin', style: TextStyle(
            color: Colors.white.withOpacity(0.65), fontSize: 14,
          )),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: BizColors.textLight, fontSize: 14),
      prefixIcon: Icon(icon, color: BizColors.textLight, size: 20),
      suffixIcon: suffix,
      filled: true,
      fillColor: BizColors.bgCard,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: BizColors.sage.withOpacity(0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: BizColors.sage.withOpacity(0.25)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: BizColors.forest, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text, style: TextStyle(
      fontSize: 12, fontWeight: FontWeight.w700,
      color: BizColors.textMuted, letterSpacing: 0.3,
    ));
  }
}
