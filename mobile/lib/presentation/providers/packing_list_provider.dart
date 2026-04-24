import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/packing_item.dart';
import '../../data/services/packing_service.dart';
import 'auth_provider.dart';

/**
 * @file packing_list_provider.dart
 * @description 行李清單狀態管理 / Packing list state management
 * @description_zh 管理行李清單數據，連動後端 API，實現個人化勾選狀態與 CRUD
 * @description_en Manages packing list data, connecting to backend API, achieving personalized check state and CRUD
 */

final packingServiceProvider = Provider((ref) => PackingService());

class PackingState {
  final List<PackingItem> items;
  final bool isLoading;
  const PackingState({this.items = const [], this.isLoading = true});
}

final packingListProvider = StateNotifierProvider<PackingListNotifier, PackingState>((ref) {
  final user = ref.watch(authProvider);
  return PackingListNotifier(ref, user?.id);
});

class PackingListNotifier extends StateNotifier<PackingState> {
  final Ref _ref;
  final String? _userId;
  final String? _tripId = '44444444-4444-4444-4444-444444444444';

  PackingListNotifier(this._ref, this._userId) : super(const PackingState()) {
    if (_userId != null) {
      fetchPackingList();
    } else {
      state = const PackingState(isLoading: false);
    }
  }

  PackingService get _service => _ref.read(packingServiceProvider);

  Future<void> fetchPackingList() async {
    if (_userId == null) return;
    state = PackingState(items: state.items, isLoading: true);
    final items = await _service.getPackingList(_userId, tripId: _tripId);
    state = PackingState(items: items, isLoading: false);
  }

  Future<void> toggleItem(String id) async {
    if (_userId == null) return;
    final currentItem = state.items.firstWhere((item) => item.id == id);
    final newStatus = !currentItem.isChecked;
    state = PackingState(isLoading: false, items: [
      for (final item in state.items)
        if (item.id == id) item.copyWith(isChecked: newStatus) else item,
    ]);
    final success = await _service.toggleItemStatus(_userId, id, newStatus, tripId: _tripId);
    if (!success) {
      state = PackingState(isLoading: false, items: [
        for (final item in state.items)
          if (item.id == id) item.copyWith(isChecked: !newStatus) else item,
      ]);
    }
  }

  Future<void> addItem(String title, String category) async {
    if (_userId == null) return;
    final newItem = await _service.createItem(title, category, tripId: _tripId, userId: _userId);
    if (newItem != null) {
      state = PackingState(isLoading: false, items: [...state.items, newItem]);
    }
  }

  Future<void> removeItem(String id) async {
    final success = await _service.deleteItem(id);
    if (success) {
      state = PackingState(isLoading: false, items: state.items.where((item) => item.id != id).toList());
    }
  }
}
