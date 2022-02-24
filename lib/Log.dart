import 'package:easy_localization/easy_localization.dart';

class Log {
  static var text = '';

  static void debug(String msg) {
    _log('DEBUG', msg);
  }

  static void info(String msg) {
    _log('INFO', msg);
  }

  static void error(String msg, String? error) {
    if (error != null) msg += ': $error';
    _log('ERROR', msg);
  }

  static void _log(String level, String msg) {
    var time = DateFormat('jms').format(DateTime.now());
    var logText = '$time [$level] $msg';
    text += '$logText\n';
    print(logText);
  }
}
