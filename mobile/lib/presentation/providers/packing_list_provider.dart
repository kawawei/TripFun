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

final packingListProvider = StateNotifierProvider<PackingListNotifier, List<PackingItem>>((ref) {
  final user = ref.watch(authProvider);
  return PackingListNotifier(ref, user?.id);
});

class PackingListNotifier extends StateNotifier<List<PackingItem>> {
  final Ref _ref;
  final String? _userId;
  final String? _tripId = '44444444-4444-4444-4444-444444444444'; // 目前暫時寫死特定行程 ID

  PackingListNotifier(this._ref, this._userId) : super([]) {
    if (_userId != null) {
      fetchPackingList();
    }
  }

  PackingService get _service => _ref.read(packingServiceProvider);

  Future<void> fetchPackingList() async {
    if (_userId == null) return;
    state = await _service.getPackingList(_userId, tripId: _tripId);
  }

  Future<void> toggleItem(String id) async {
    if (_userId == null) return;
    
    // 先樂觀更新 UI / Optimistically update UI
    final currentItem = state.firstWhere((item) => item.id == id);
    final newStatus = !currentItem.isChecked;
    
    state = [
      for (final item in state)
        if (item.id == id)
          item.copyWith(isChecked: newStatus)
        else
          item,
    ];

    // 同步到後端 / Sync to backend
    final success = await _service.toggleItemStatus(_userId, id, newStatus, tripId: _tripId);
    if (!success) {
      // 如果失敗，回滾狀態 / Rollback on failure
      state = [
        for (final item in state)
          if (item.id == id)
            item.copyWith(isChecked: !newStatus)
          else
            item,
      ];
    }
  }

  Future<void> addItem(String title, String category) async {
    if (_userId == null) return;
    
    final newItem = await _service.createItem(
      title, 
      category, 
      tripId: _tripId, 
      userId: _userId
    );
    
    if (newItem != null) {
      state = [...state, newItem];
    }
  }

  Future<void> removeItem(String id) async {
    final success = await _service.deleteItem(id);
    if (success) {
      state = state.where((item) => item.id != id).toList();
    }
  }
}
