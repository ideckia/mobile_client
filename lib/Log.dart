
class Log {
  
  static void info(String msg) {
    _log('INFO', msg);
  }
  
  static void error(String msg, error) {
    _log('ERROR', msg + ': $error');
  }
  
  static void _log(String level, String msg) {
    print('[$level] $msg');
  }
}