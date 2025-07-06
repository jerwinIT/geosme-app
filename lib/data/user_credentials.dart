import '../models/user.dart';

class UserData {
  static final List<UserCredentials> users = [
    UserCredentials(
      email: 'admin@geosme.com',
      password: 'admin123',
      name: 'Admin User',
    ),
    UserCredentials(
      email: 'user@geosme.com',
      password: 'user123',
      name: 'Regular User',
    ),
    UserCredentials(
      email: 'demo@geosme.com',
      password: 'demo123',
      name: 'Demo User',
    ),
    UserCredentials(
      email: 'test@geosme.com',
      password: 'test123',
      name: 'Test User',
    ),
  ];

  static UserCredentials? authenticateUser(String email, String password) {
    try {
      return users.firstWhere(
        (user) =>
            user.email.toLowerCase() == email.toLowerCase() &&
            user.password == password,
      );
    } catch (e) {
      return null;
    }
  }

  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  static List<String> getSampleEmails() {
    return users.map((user) => user.email).toList();
  }
}
