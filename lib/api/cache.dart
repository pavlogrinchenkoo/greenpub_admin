import 'dart:html' as html;

class Cache {
  void saveCookie(String key, String value) {
    html.document.cookie =
        '$key=$value; expires=${DateTime.now().add(const Duration(days: 30))}';
  }

  String? getCookie(String key) {
    final cookies = html.document.cookie?.split(';');
    for (final cookie in cookies!) {
      final keyValue = cookie.split('=');
      if (keyValue.length == 2) {
        final k = keyValue[0].trim();
        final v = keyValue[1].trim();
        if (k == key) {
          return v;
        }
      }
    }
    return null;
  }
}
