// create DateUtils class to handle date formatting and parsing

// Path: lib\utils\dates.dart

class DateUtil {
  static String dateOnly({required DateTime date}) {
    return "${date.toLocal()}".split(' ')[0];
  }

  static String timeOnly({required DateTime date}) {
    return "${date.toLocal()}".split(' ')[1];
  }

  static String dateAndTime({required DateTime date}) {
    return "${date.toLocal()}".split('.')[0];
  }

  // create a function to parse date string to dateOnly and return string date Only
  static String parseDateOnly({required String date}) {
    return date.split(' ')[0];
  }

  static String parseTimeOnly({required String date}) {
    return date.split(' ')[1];
  }

  static parseDateTime(String dateTimeString) {
    final parts = dateTimeString.split(" ");
    final datePart = parts[0];
    final timePart = parts[1].substring(0, 5); // Extract HH:mm from time part

    final dateParts = datePart.split("-");
    final year = int.parse(dateParts[0]);
    final month = int.parse(dateParts[1]);
    final day = int.parse(dateParts[2]);

    final timeParts = timePart.split(":");
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    return DateTime(year, month, day, hour, minute);
  }
}
