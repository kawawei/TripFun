import { Module } from '@nestjs/common';
import { MulterModule } from '@nestjs/platform-express';
import { UploadController } from './controllers/upload.controller';
import { UploadService } from './services/upload.service';
import { diskStorage } from 'multer';
import { extname } from 'path';

/**
 * @file upload.module.ts
 * @description 檔案上傳模組 / File Upload Module
 * @description_zh 統一管理檔案上傳配置，支援 10MB 限制與自動壓縮對接
 */

@Module({
  imports: [
    MulterModule.register({
      limits: {
        fileSize: 10 * 1024 * 1024, // 支援最高 10MB / Support up to 10MB
      },
      storage: diskStorage({
        destination: './uploads',
        filename: (req, file, cb) => {
          const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1e9);
          cb(null, `${file.fieldname}-${uniqueSuffix}${extname(file.originalname)}`);
        },
      }),
    }),
  ],
  controllers: [UploadController],
  providers: [UploadService],
})
export class UploadModule {}
