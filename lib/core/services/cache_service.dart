import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  Future<void> saveCache(String key, Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheData = {
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'data': data,
    };
    await prefs.setString(key, json.encode(cacheData));
  }

  Future<Map<String, dynamic>?> getCache(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(key);

    if (jsonString == null) return null;

    return json.decode(jsonString);
  }

  bool isCacheValid(
    Map<String, dynamic> cacheWrapper,
    int expirationInMinutes,
  ) {
    final timestamp = cacheWrapper['timestamp'] as int;
    final savedTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final diff = DateTime.now().difference(savedTime);
    return diff.inMinutes < expirationInMinutes;
  }

  Future<void> removeCache(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
