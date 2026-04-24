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
    // 獲取所有項目 (包括系統預設與該行程的自定義項目)
    const items = await this.itemRepository.find({
      where: [
        { is_custom: false },
        { trip_id: tripId },
      ],
      order: { category: 'ASC', created_at: 'ASC' }
    });

    // 獲取使用者的核取狀態
    const statuses = await this.statusRepository.find({
      where: { user_id: userId, trip_id: tripId }
    });

    const statusMap = new Map(statuses.map(s => [s.item_id, s.is_checked]));

    return items.map(item => ({
      ...item,
      isChecked: statusMap.get(item.id) || false
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
