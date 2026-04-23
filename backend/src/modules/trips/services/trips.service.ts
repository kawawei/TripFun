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
        memberCount: 1,
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
        },
        {
          trip_id: laTrip.id,
          time: '10:00 (5/1)',
          title: '大韓航空前往首爾',
          subtitle: '仁川國際機場 (ICN)',
          type: 'FLIGHT',
          icon_name: 'plane',
          personal_info: {
            '航空公司': '大韓航空',
            '日期': '5月1日',
          },
        },
        {
          trip_id: laTrip.id,
          time: '18:00 (5/2)',
          title: '抵達首爾 & 明洞晚餐',
          subtitle: '享受正宗韓式料理',
          type: 'FOOD',
          icon_name: 'utensils',
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
      order: { time: 'ASC' },
    });
  }

  async create(tripData: Partial<Trip>): Promise<Trip> {
    const trip = this.tripRepository.create(tripData);
    return this.tripRepository.save(trip);
  }
}
