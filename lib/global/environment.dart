import 'dart:io';

class Environment {
  static String apiUrl = Platform.isAndroid
      ? 'http://192.168.18.5:3001/api/v1'
      : 'http://192.168.18.5:3001/api/v1';

  static String socketUrl = Platform.isAndroid
      ? 'http://192.168.18.5:3001'
      : 'http://192.168.18.5:3001';
}
