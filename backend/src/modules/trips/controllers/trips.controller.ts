import { Controller, Get, Post, Body } from '@nestjs/common';
import { TripsService } from '../services/trips.service';

@Controller('trips')
export class TripsController {
  constructor(private readonly tripsService: TripsService) {}

  @Get()
  async findAll() {
    return this.tripsService.findAll();
  }

  @Post()
  async create(@Body() createTripDto: any) {
    return this.tripsService.create(createTripDto);
  }
}
