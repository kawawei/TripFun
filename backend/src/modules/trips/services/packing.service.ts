import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { PackingItem } from '../entities/packing-item.entity';
import { UserPackingStatus } from '../entities/user-packing-status.entity';

/**
 * @file packing.service.ts
 * @description 行李清單管理服務 / Packing List Management Service
 * @description_zh 負責行李項目的 CRUD 與使用者勾選狀態管理
 * @description_en Handles CRUD for packing items and user check status management
 */

@Injectable()
export class PackingService {
  constructor(
    @InjectRepository(PackingItem)
    private readonly itemRepository: Repository<PackingItem>,
    @InjectRepository(UserPackingStatus)
    private readonly statusRepository: Repository<UserPackingStatus>,
  ) {}


  /**
   * 獲取完整清單（包含特定使用者的勾選狀態）
   */
  async getPackingList(userId: string, tripId?: string) {
    // ========================================
    // 只取手動新增的項目（依 trip_id 篩選，不使用系統預設清單）
    // Only fetch manually added items by trip_id, no default seed data
    // ========================================
    const whereClause = tripId ? { trip_id: tripId } : {};
    const items = await this.itemRepository.find({
      where: whereClause,
      order: { category: 'ASC', created_at: 'ASC' },
    });

    if (items.length === 0) return [];

    // 取得使用者的個別勾選狀態 / Fetch per-user check status
    const itemIds = items.map((i) => i.id);
    const statuses = await this.statusRepository
      .createQueryBuilder('s')
      .where('s.user_id = :userId', { userId })
      .andWhere('s.item_id IN (:...itemIds)', { itemIds })
      .getMany();

    const statusMap = new Map(statuses.map((s) => [s.item_id, s.is_checked]));

    return items.map((item) => ({
      id: item.id,
      title: item.title,
      category: item.category,
      is_custom: item.is_custom,
      trip_id: item.trip_id,
      isChecked: statusMap.get(item.id) ?? false,
    }));
  }

  /**
   * 切換勾選狀態
   */
  async toggleItemStatus(userId: string, itemId: string, isChecked: boolean, tripId?: string) {
    let status = await this.statusRepository.findOne({
      where: { user_id: userId, item_id: itemId, trip_id: tripId }
    });

    if (status) {
      status.is_checked = isChecked;
      return this.statusRepository.save(status);
    } else {
      status = this.statusRepository.create({
        user_id: userId,
        item_id: itemId,
        trip_id: tripId,
        is_checked: isChecked
      });
      return this.statusRepository.save(status);
    }
  }

  /**
   * 項目增刪改查 (CRUD)
   */
  async createItem(itemData: Partial<PackingItem>) {
    const item = this.itemRepository.create(itemData);
    return this.itemRepository.save(item);
  }

  async updateItem(id: string, itemData: Partial<PackingItem>) {
    await this.itemRepository.update(id, itemData);
    return this.itemRepository.findOne({ where: { id } });
  }

  async deleteItem(id: string) {
    // 刪除項目的同時，也應該刪除相關的勾選狀態
    await this.statusRepository.delete({ item_id: id });
    return this.itemRepository.delete(id);
  }
}
