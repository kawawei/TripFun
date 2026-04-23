import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { TripsController } from './controllers/trips.controller';
import { TripsService } from './services/trips.service';
import { Trip } from './entities/trip.entity';
import { Activity } from './entities/activity.entity';

/**
 * @file trips.module.ts
 * @description 行程管理模組 / Trips Module
 * @description_zh 負責註冊行程相關控制器、服務與資料庫實體
 * @description_en Responsible for registering trip controllers, services, and database entities
 */

@Module({
  imports: [
    TypeOrmModule.forFeature([Trip, Activity]),
  ],
  controllers: [TripsController],
  providers: [TripsService],
  exports: [TripsService],
})
export class TripsModule {}
