import { Module } from '@nestjs/common';
import { HealthController } from './health.controller';

/**
 * @file health.module.ts
 * @description 健康檢查模組 / Health Check Module
 */

@Module({
  controllers: [HealthController],
})
export class HealthModule {}
