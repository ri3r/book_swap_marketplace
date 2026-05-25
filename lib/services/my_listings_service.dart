import 'package:shared_preferences/shared_preferences.dart';

class MyListingsService {
  static const _key = 'my_listing_ids';

  Future<Set<String>> load() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_key) ?? []).toSet();
  }

  Future<void> add(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_key) ?? [];
    if (!ids.contains(id)) {
      await prefs.setStringList(_key, [...ids, id]);
    }
  }

  Future<void> remove(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final ids = (prefs.getStringList(_key) ?? []).toList();
    ids.remove(id);
    await prefs.setStringList(_key, ids);
  }
}
