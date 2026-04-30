import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { TripsModule } from './modules/trips/trips.module';
import { Trip } from './modules/trips/entities/trip.entity';
import { Activity } from './modules/trips/entities/activity.entity';
import { PackingItem } from './modules/trips/entities/packing-item.entity';
import { UserPackingStatus } from './modules/trips/entities/user-packing-status.entity';
import { Expense } from './modules/trips/entities/expense.entity';
import { UploadModule } from './modules/upload/upload.module';
import { ServeStaticModule } from '@nestjs/serve-static';
import { join } from 'path';

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
        entities: [Trip, Activity, PackingItem, UserPackingStatus, Expense],
        synchronize: true, // 僅限開發環境使用 / Development only
      }),
      inject: [ConfigService],
    }),
    ServeStaticModule.forRoot({
      rootPath: join(__dirname, '..', 'uploads'),
      serveRoot: '/uploads',
      serveStaticOptions: {
        setHeaders: (res, path, stat) => {
          res.set('Access-Control-Allow-Origin', '*');
        },
      },
    }),
    TripsModule,
    UploadModule,
  ],
  controllers: [],
  providers: [],
})
export class AppModule {}
