import { Controller, Post, UseInterceptors, UploadedFile, BadRequestException } from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';

/**
 * @file upload.controller.ts
 * @description 檔案上傳控制器 / File Upload Controller
 */

@Controller('upload')
export class UploadController {
  @Post('image')
  @UseInterceptors(FileInterceptor('image'))
  uploadImage(@UploadedFile() file: Express.Multer.File) {
    if (!file) {
      throw new BadRequestException('請選擇要上傳的圖片 / Please select an image');
    }
    
    // 返回圖片 URL (後續可根據環境變數配置完整網址)
    return {
      url: `/uploads/${file.filename}`,
      size: file.size,
      mimetype: file.mimetype,
    };
  }
}
