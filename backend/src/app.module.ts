import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { TripsModule } from './modules/trips/trips.module';
import { Trip } from './modules/trips/entities/trip.entity';
import { Activity } from './modules/trips/entities/activity.entity';

/**
 * @file app.module.ts
 * @description 應用程序根模組 / Application Root Module
 * @description_zh 配置全域 Config、資料庫連線 (TypeORM) 與功能模組
 * @description_en Configures global Config, Database connection (TypeORM), and feature modules
 */

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: '.env',
    }),
    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      useFactory: (configService: ConfigService) => ({
        type: 'postgres',
        host: configService.get<string>('DB_HOST', 'localhost'),
        port: configService.get<number>('DB_PORT', 5432),
        username: configService.get<string>('DB_USER', 'postgres'),
        password: configService.get<string>('DB_PASSWORD', 'tripfun_pass'),
        database: configService.get<string>('DB_NAME', 'tripfun_db'),
        entities: [Trip, Activity],
        synchronize: true, // 僅限開發環境使用 / Development only
      }),
      inject: [ConfigService],
    }),
    TripsModule,
  ],
  controllers: [],
  providers: [],
})
export class AppModule {}
