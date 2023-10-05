import 'dart:math';

class RandomUtils {
  static const String _lowerChars = 'abcdefghijklmnopqrstuvwxyz';
  static const String _upperChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static const String _numbers = '0123456789';
  static const String _specialChars = '!@#\$%^&*()-_=+{}[]|;:,.<>?';

  static String generatePassword({int length = 10}) {
    String chars = '$_lowerChars$_upperChars$_numbers$_specialChars';
    String password = '';
    Random random = Random();

    for (int i = 0; i < length; i++) {
      password += chars[random.nextInt(chars.length)];
    }

    return password;
  }

  static String generateId({int length = 10}) {
    String chars = '$_lowerChars$_upperChars$_numbers';
    String id = '';
    Random random = Random();

    for (int i = 0; i < length; i++) {
      id += chars[random.nextInt(chars.length)];
    }

    return id;
  }
}
