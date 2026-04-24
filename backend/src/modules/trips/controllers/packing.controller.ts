import { Controller, Get, Post, Put, Delete, Patch, Body, Param, Query } from '@nestjs/common';
import { PackingService } from '../services/packing.service';

/**
 * @file packing.controller.ts
 * @description 行李清單控制器 / Packing List Controller
 * @description_zh 處理行李清單的 API 請求
 * @description_en Handles API requests for packing list
 */

@Controller('trips/packing')
export class PackingController {
  constructor(private readonly packingService: PackingService) {}

  @Get()
  async getList(
    @Query('userId') userId: string,
    @Query('tripId') tripId?: string,
  ) {
    return this.packingService.getPackingList(userId, tripId);
  }

  @Post('items')
  async createItem(@Body() itemData: any) {
    return this.packingService.createItem(itemData);
  }

  @Put('items/:id')
  async updateItem(@Param('id') id: string, @Body() itemData: any) {
    return this.packingService.updateItem(id, itemData);
  }

  @Delete('items/:id')
  async deleteItem(@Param('id') id: string) {
    return this.packingService.deleteItem(id);
  }

  @Patch('items/:id/status')
  async toggleStatus(
    @Param('id') itemId: string,
    @Body('userId') userId: string,
    @Body('isChecked') isChecked: boolean,
    @Body('tripId') tripId?: string,
  ) {
    return this.packingService.toggleItemStatus(userId, itemId, isChecked, tripId);
  }
}
