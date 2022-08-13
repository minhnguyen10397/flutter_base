import 'dart:developer';

class AppLog {
  ///use Log.v. Print all Logs
  static const int VERBOSE = 2;

  ///use Log.d. Print Debug Logs
  static const int DEBUG = 3;

  ///use Log.i. Print Info Logs
  static const int INFO = 4;

  ///use Log.w. Print warning logs
  static const int WARN = 5;

  ///use Log.e. Print error logs
  static const int ERROR = 6;

  static _log(int priority, String tag, String message) {
    log(_getPriorityText(priority) + tag + ": " + message);
  }

  static String _getPriorityText(int priority) {
    switch (priority) {
      case INFO:
        return "INFOⓘ|";
      case DEBUG:
        return "DEBUG|";
      case ERROR:
        return "ERROR⚠️|️";
      case WARN:
        return "WARN⚠️|";
      case VERBOSE:
      default:
        return "";
    }
  }

  ///Print general logs
  static v(String tag, String message) {
    _log(VERBOSE, tag, message);
  }

  ///Print info logs
  static i(String tag, String message) {
    _log(INFO, tag, message);
  }

  ///Print debug logs
  static d(String tag, String message) {
    _log(DEBUG, tag, message);
  }

  ///Print warning logs
  static w(String tag, String message) {
    _log(WARN, tag, message);
  }

  ///Print error logs
  static e(String tag, String message) {
    _log(ERROR, tag, message);
  }
}