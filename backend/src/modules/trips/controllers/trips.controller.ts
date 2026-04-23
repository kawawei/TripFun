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

  @Post()
  async create(@Body() createTripDto: any) {
    return this.tripsService.create(createTripDto);
  }
}
