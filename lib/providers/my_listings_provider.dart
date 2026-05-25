import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/my_listings_service.dart';

class MyListingsNotifier extends StateNotifier<Set<String>> {
  final MyListingsService _service;

  MyListingsNotifier(this._service) : super(const {}) {
    _load();
  }

  Future<void> _load() async {
    state = await _service.load();
  }

  Future<void> add(String id) async {
    await _service.add(id);
    state = {...state, id};
  }

  Future<void> remove(String id) async {
    await _service.remove(id);
    state = state.where((e) => e != id).toSet();
  }
}

final myListingsProvider =
    StateNotifierProvider<MyListingsNotifier, Set<String>>(
  (ref) => MyListingsNotifier(MyListingsService()),
);
