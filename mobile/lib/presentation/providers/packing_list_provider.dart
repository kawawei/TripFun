import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/packing_item.dart';
import '../../data/services/packing_service.dart';
import '../../data/repositories/packing_repository_impl.dart';
import 'auth_provider.dart';

/**
 * @file packing_list_provider.dart
 * @description 行李清單狀態管理 / Packing list state management
 * @description_zh 管理行李清單數據，連動後端 API，實現個人化勾選狀態與 CRUD，支援 Isar 離線快取
 * @description_en Manages packing list data, connecting to backend API, achieving personalized check state and CRUD, supporting Isar offline caching
 */

final packingServiceProvider = Provider((ref) => PackingService());

class PackingState {
  final List<PackingItem> items;
  final bool isLoading;
  const PackingState({this.items = const [], this.isLoading = true});
}

final packingListProvider = StateNotifierProvider<PackingListNotifier, PackingState>((ref) {
  final user = ref.watch(authProvider);
  final repository = ref.watch(packingRepositoryProvider);
  return PackingListNotifier(ref, repository, user?.id);
});

class PackingListNotifier extends StateNotifier<PackingState> {
  final Ref _ref;
  final PackingRepositoryImpl _repository;
  final String? _userId;
  final String? _tripId = '44444444-4444-4444-4444-444444444444';

  PackingListNotifier(this._ref, this._repository, this._userId) : super(const PackingState()) {
    if (_userId != null) {
      fetchPackingList();
    } else {
      state = const PackingState(isLoading: false);
    }
  }

  Future<void> fetchPackingList() async {
    if (_userId == null) return;
    state = PackingState(items: state.items, isLoading: true);
    try {
      final items = await _repository.getPackingList(_userId!, tripId: _tripId);
      state = PackingState(items: items, isLoading: false);
    } catch (e) {
      state = PackingState(items: state.items, isLoading: false);
    }
  }

  Future<void> toggleItem(String id) async {
    if (_userId == null) return;
    final currentItem = state.items.firstWhere((item) => item.id == id);
    final newStatus = !currentItem.isChecked;
    
    // 樂觀更新 UI
    state = PackingState(isLoading: false, items: [
      for (final item in state.items)
        if (item.id == id) item.copyWith(isChecked: newStatus) else item,
    ]);

    try {
      final success = await _repository.toggleItemStatus(_userId!, id, newStatus, tripId: _tripId);
      if (!success) {
        // 失敗則回滾
        state = PackingState(isLoading: false, items: [
          for (final item in state.items)
            if (item.id == id) item.copyWith(isChecked: !newStatus) else item,
        ]);
      }
    } catch (e) {
      // 發生異常也回滾 (除非 repository 內部已經處理了離線狀態)
      // 註：PackingRepositoryImpl 內部會先更新本地 Isar，所以這裡可以視情況處理
    }
  }

  Future<void> addItem(String title, String category) async {
    if (_userId == null) return;
    final service = _ref.read(packingServiceProvider);
    final newItem = await service.createItem(title, category, tripId: _tripId, userId: _userId);
    if (newItem != null) {
      state = PackingState(isLoading: false, items: [...state.items, newItem]);
      // 重新獲取以更新快取 (或手動同步快取)
      fetchPackingList();
    }
  }

  Future<void> removeItem(String id) async {
    final service = _ref.read(packingServiceProvider);
    final success = await service.deleteItem(id);
    if (success) {
      state = PackingState(isLoading: false, items: state.items.where((item) => item.id != id).toList());
      // 重新獲取以更新快取
      fetchPackingList();
    }
  }
}
