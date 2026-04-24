import { Injectable, OnModuleInit } from '@nestjs/common';
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
export class PackingService implements OnModuleInit {
  constructor(
    @InjectRepository(PackingItem)
    private readonly itemRepository: Repository<PackingItem>,
    @InjectRepository(UserPackingStatus)
    private readonly statusRepository: Repository<UserPackingStatus>,
  ) {}

  async onModuleInit() {
    await this.initializeDefaultItems();
  }

  /**
   * 初始化預設清單 / Initialize default items
   */
  private async initializeDefaultItems() {
    const count = await this.itemRepository.count();
    if (count === 0) {
      const defaultItems = [
        // 重要證件與金流
        { title: '護照 (及其影本)', category: '重要證件與金流' },
        { title: '美簽 (ESTA/Visa)', category: '重要證件與金流' },
        { title: '韓簽 (K-ETA)', category: '重要證件與金流' },
        { title: '國際機票 (電子/紙本)', category: '重要證件與金流' },
        { title: '外幣現金 (USD, KRW)', category: '重要證件與金流' },
        { title: '信用卡 (海外刷卡推薦)', category: '重要證件與金流' },
        
        // 電子產品與配件
        { title: '萬用轉接頭 (美國與台灣相同，韓國為歐規)', category: '電子產品與配件' },
        { title: '變壓器 (注意韓國為 220V)', category: '電子產品與配件' },
        { title: '行動電源', category: '電子產品與配件' },
        { title: '多孔充電頭與線材', category: '電子產品與配件' },
        { title: 'eSIM / 網卡 / Wi-Fi 分享器', category: '電子產品與配件' },
        
        // 個人衣物與穿戴
        { title: '換洗衣物', category: '個人衣物與穿戴' },
        { title: '保暖外套 (美國長程航程冷, 韓國四季分明)', category: '個人衣物與穿戴' },
        { title: '舒適運動鞋', category: '個人衣物與穿戴' },
        { title: '太陽眼鏡', category: '個人衣物與穿戴' },
        
        // 盥洗物品
        { title: '牙刷、牙膏 (美國飯店常不提供)', category: '盥洗物品' },
        { title: '洗面乳、個人護膚品', category: '盥洗物品' },
        { title: '防曬乳', category: '盥洗物品' },
        { title: '刮鬍刀', category: '盥洗物品' },
        
        // 常備藥品與防疫
        { title: '感冒藥、止痛藥', category: '常備藥品與防疫' },
        { title: '腸胃藥', category: '常備藥品與防疫' },
        { title: '個人長期服用藥物', category: '常備藥品與防疫' },
        { title: '口罩與乾洗手', category: '常備藥品與防疫' },
        
        // 旅遊票券與計畫
        { title: '飯店預約單', category: '旅遊票券與計畫' },
        { title: '旅遊保險證明', category: '旅遊票券與計畫' },
        { title: '主題樂園/門票 (如迪士尼、環球影城)', category: '旅遊票券與計畫' },
        
        // 長程飛行與生活雜物
        { title: '頸枕、眼罩 (美國長途必備)', category: '長程飛行與生活雜物' },
        { title: '環保購物袋 (韓國很多超市不提供塑膠袋)', category: '長程飛行與生活雜物' },
        { title: '空水壺 (入關後裝水)', category: '長程飛行與生活雜物' },
        
        // 目的地特定項目
        { title: 'T-Money卡 (韓國交通卡)', category: '目的地特定項目' },
        { title: 'Naver Map/Kakao Map (韓國導航)', category: '目的地特定項目' },
        { title: 'Uber/Lyft APP (美國叫車)', category: '目的地特定項目' },
      ];

      await this.itemRepository.save(
        defaultItems.map(item => ({ ...item, is_custom: false }))
      );
      console.log('Default packing list initialized.');
    }
  }

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
