import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { Logger } from '@nestjs/common';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  const logger = new Logger('Bootstrap');
  
  app.setGlobalPrefix('api/v1'); // 設定全域 API 前綴 / Set global API prefix
  
  const port = process.env.PORT || 3000;
  app.enableCors(); // 啟用跨來源資源共享 / Enable CORS
  await app.listen(port);
  
  logger.log(`TripFun Backend is running on: http://localhost:${port}`);
}
bootstrap();
