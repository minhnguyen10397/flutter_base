import 'package:intl/intl.dart';

enum DateTimeFormat {
  dd_MM_yyyy,
  dd_MMM_yyyy,
  yyyy_MM_dd,
  yyyy_MM_ddTHH_mm_ss,
}

extension DateTimeFormatExtension on DateTimeFormat {
  String get getString {
    switch (this) {
      case DateTimeFormat.yyyy_MM_ddTHH_mm_ss:
        return "yyyy-MM-dd'T'HH:mm:ss";
      case DateTimeFormat.dd_MM_yyyy:
        return "dd/MM/yyyy";
      case DateTimeFormat.dd_MMM_yyyy:
        return "dd-MMM-yyyy";
      case DateTimeFormat.yyyy_MM_dd:
        return "yyyy-MM-dd";
      default:
        return "dd/MM/yyyy";
    }
  }
}

class DateTimeUtil {

  static String convertDate(
    String dateString, {
        DateTimeFormat fromFormat = DateTimeFormat.yyyy_MM_dd,
        DateTimeFormat toFormat = DateTimeFormat.dd_MM_yyyy,
    bool isFromUtc = true,
  }) {
    if (isFromUtc) {
      final date =
          DateFormat(fromFormat.getString).parseUTC(dateString).toLocal();
      return DateFormat(toFormat.getString).format(date);
    }
    final date = DateFormat(fromFormat.getString).parse(dateString);
    return DateFormat(toFormat.getString).format(date);
  }

  static DateTime getDate(
    String date, {
    DateTimeFormat format = DateTimeFormat.dd_MM_yyyy,
  }) {
    try {
      return DateFormat(format.getString).parseUTC(date).toLocal();
    } catch (e) {
      throw FormatException('Characters remaining after date parsing in $date');
    }
  }

  static String getString(
    DateTime date, {
    DateTimeFormat format = DateTimeFormat.dd_MM_yyyy,
  }) {
    try {
      return DateFormat(format.getString).format(date);
    } catch (e) {
      throw FormatException('Characters remaining after date parsing in $date');
    }
  }

  static bool isDate(String input, {DateTimeFormat format = DateTimeFormat.dd_MMM_yyyy}) {
    try {
      DateFormat(format.getString).parseStrict(input);
      return true;
    } catch (e) {
      return false;
    }
  }
}
