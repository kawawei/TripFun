import { Injectable, OnModuleInit } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Trip } from '../entities/trip.entity';
import { Activity } from '../entities/activity.entity';

/**
 * @file trips.service.ts
 * @description 行程管理服務 / Trip Management Service
 * @description_zh 負責行程與活動的 CRUD 操作，對接 PostgreSQL 資料庫
 * @description_en Handles CRUD operations for trips and activities, connecting to PostgreSQL
 */

@Injectable()
export class TripsService implements OnModuleInit {
  constructor(
    @InjectRepository(Trip)
    private readonly tripRepository: Repository<Trip>,
    @InjectRepository(Activity)
    private readonly activityRepository: Repository<Activity>,
  ) {}

  /**
   * 初始化數據 / Initialize data
   * 如果資料庫為空，則插入測試數據 / Seed test data if the database is empty
   */
  async onModuleInit() {
    const count = await this.tripRepository.count();
    if (count === 0) {
      const laTrip = await this.tripRepository.save({
        id: '44444444-4444-4444-4444-444444444444', // 固定 UUID 方便測試
        title: '洛杉磯與關島跨國之旅',
        location: '關島 & 首爾',
        startDate: new Date('2026-04-25T11:00:00Z'),
        endDate: new Date('2026-05-03T12:00:00Z'),
        memberCount: 4,
        icon_name: 'plane',
        color_value: 0xFF10b981,
        status: 'ACTIVE',
      });

      await this.activityRepository.save([
        {
          trip_id: laTrip.id,
          time: '07:00',
          title: '出發前往機場',
          subtitle: '準備搭乘跨國航班',
          type: 'TRANSPORT',
          icon_name: 'car',
        },
        {
          trip_id: laTrip.id,
          time: '08:00',
          title: '桃園機場第二航廈',
          subtitle: 'Check-in 前往貴賓室吃飯休息',
          type: 'FLIGHT',
          icon_name: 'plane-landing',
        },
        {
          trip_id: laTrip.id,
          time: '11:00',
          title: '美國聯合航空 UA166',
          subtitle: '起飛前往關島 (GUM)',
          type: 'FLIGHT',
          icon_name: 'plane',
          personal_info: {
            '航班編號': 'UA166',
            '航空公司': '美國聯合航空',
            '目的地': '關島',
          },
        },
        {
          trip_id: laTrip.id,
          time: '17:00',
          title: '抵達關島',
          subtitle: '開啟海島假期',
          type: 'ATTRACTION',
          icon_name: 'map-pin',
          image_urls: [
            'https://images.unsplash.com/photo-1544257750-572358f5da22?q=80&w=800',
            'https://images.unsplash.com/photo-1536431311719-398b6704d4cc?q=80&w=800',
            'https://images.unsplash.com/photo-1510414842594-a61c69b5ae57?q=80&w=800'
          ],
        },
        {
          trip_id: laTrip.id,
          time: '18:00 (5/2)',
          title: '抵達首爾 & 明洞晚餐',
          subtitle: '享受正宗韓式料理',
          type: 'FOOD',
          icon_name: 'utensils',
          image_urls: [
            'https://images.unsplash.com/photo-159060451804e-ab90437452d3?q=80&w=800',
            'https://images.unsplash.com/photo-1538481199705-c710c4e965fc?q=80&w=800'
          ],
          personal_info: {
            '航空公司': '大韓航空',
            '日期': '5月1日',
          },
        },
        {
          trip_id: laTrip.id,
          time: '12:00 (5/3)',
          title: '返程班機',
          subtitle: '返回台灣',
          type: 'FLIGHT',
          icon_name: 'plane',
        }
      ]);
      console.log('Seed data initialized successfully.');
    }
  }

  async findAll(): Promise<Trip[]> {
    return this.tripRepository.find({
      order: { startDate: 'ASC' },
    });
  }

  async findActivitiesByTripId(tripId: string): Promise<Activity[]> {
    return this.activityRepository.find({
      where: { trip_id: tripId },
      order: { sort_order: 'ASC', time: 'ASC' },
    });
  }

  async create(tripData: Partial<Trip>): Promise<Trip> {
    const trip = this.tripRepository.create(tripData);
    return this.tripRepository.save(trip);
  }

  async createActivity(activityData: Partial<Activity>): Promise<Activity> {
    const activity = this.activityRepository.create(activityData);
    return this.activityRepository.save(activity);
  }

  async findOne(id: string): Promise<Trip> {
    return this.tripRepository.findOne({ where: { id } });
  }

  async updateMembers(id: string, members: any[]): Promise<Trip> {
    await this.tripRepository.update(id, { members });
    return this.findOne(id);
  }

  /**
   * 更新活動 / Update activity
   * @param id 活動 ID
   * @param activityData 更新的數據
   */
  async updateActivity(id: string, activityData: Partial<Activity>): Promise<Activity> {
    await this.activityRepository.update(id, activityData);
    return this.activityRepository.findOne({ where: { id } });
  }
}
