class BizAuthService {
  static bool isLoggedIn = false;
  static Map<String, String> currentUser = {};

  static const List<Map<String, String>> _users = [
    {
      'name': 'SmilePro Dental',
      'email': 'admin@smilepro.az',
      'password': 'SmilePro123',
      'role': 'admin',
    },
  ];

  static bool login(String email, String password) {
    final input = email.trim().toLowerCase();
    for (final u in _users) {
      if (u['email']!.toLowerCase() == input && u['password'] == password) {
        isLoggedIn = true;
        currentUser = Map<String, String>.from(u);
        return true;
      }
    }
    return false;
  }

  static void logout() {
    isLoggedIn = false;
    currentUser = {};
  }

  static String get businessName => currentUser['name'] ?? 'Business';
  static String get email => currentUser['email'] ?? '';
}
