import { Controller, Get, Post, Body, Param } from '@nestjs/common';
import { TripsService } from '../services/trips.service';

@Controller('trips')
export class TripsController {
  constructor(private readonly tripsService: TripsService) {}

  @Get()
  async findAll() {
    return this.tripsService.findAll();
  }

  @Get(':id/activities')
  async findActivities(@Param('id') id: string) {
    return this.tripsService.findActivitiesByTripId(id);
  }

  @Get(':id/members')
  async findMembers(@Param('id') id: string) {
    // 回傳預設的成員名單 (未來可接資料庫 user 表)
    return [
      { id: 'u1', name: 'Kawa' },
      { id: 'u2', name: 'Kelly' },
      { id: 'u3', name: 'Amber' },
      { id: 'u4', name: 'Vivian' },
    ];
  }

  @Post()
  async create(@Body() createTripDto: any) {
    return this.tripsService.create(createTripDto);
  }

  @Post(':id/activities')
  async createActivity(@Param('id') trip_id: string, @Body() activityData: any) {
    return this.tripsService.createActivity({ ...activityData, trip_id });
  }

  @Post('activities/:id')
  async updateActivity(@Param('id') id: string, @Body() activityData: any) {
    return this.tripsService.updateActivity(id, activityData);
  }
}
