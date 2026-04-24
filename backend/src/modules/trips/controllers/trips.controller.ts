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
    const trip = await this.tripsService.findOne(id);
    if (trip && trip.members && trip.members.length > 0) {
      return trip.members;
    }
    // 回傳空的或初始的以免出錯
    return [];
  }

  @Post(':id/members')
  async updateMembers(@Param('id') id: string, @Body() membersData: any[]) {
    return this.tripsService.updateMembers(id, membersData);
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
