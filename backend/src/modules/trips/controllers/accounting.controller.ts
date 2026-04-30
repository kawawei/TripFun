import { Controller, Get, Post, Body, Param, Delete } from '@nestjs/common';
import { AccountingService } from '../services/accounting.service';

/**
 * @file accounting.controller.ts
 * @description 記帳管理控制器 / Accounting Management Controller
 * @description_zh 提供記帳數據的 API 接口，支援批次同步
 * @description_en Provides API endpoints for accounting data, supporting batch sync
 */

@Controller('accounting')
export class AccountingController {
  constructor(private readonly accountingService: AccountingService) {}

  @Get('trip/:tripId')
  async findAll(@Param('tripId') tripId: string) {
    return this.accountingService.findAllByTripId(tripId);
  }

  @Post('sync')
  async sync(@Body() expenses: any[]) {
    return this.accountingService.sync(expenses);
  }

  @Post()
  async create(@Body() expenseData: any) {
    return this.accountingService.create(expenseData);
  }

  @Delete(':id')
  async remove(@Param('id') id: string) {
    await this.accountingService.remove(id);
    return { success: true };
  }
}
