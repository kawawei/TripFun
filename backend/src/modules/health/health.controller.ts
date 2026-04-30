import { Controller, Get } from '@nestjs/common';

/**
 * @file health.controller.ts
 * @description 健康檢查控制器 / Health Check Controller
 * @description_zh 提供 Docker 容器健康檢查所需的接口
 * @description_en Provides endpoints for Docker container health checks
 */

@Controller('health')
export class HealthController {
  @Get()
  check() {
    return {
      status: 'ok',
      timestamp: new Date().toISOString(),
    };
  }
}
