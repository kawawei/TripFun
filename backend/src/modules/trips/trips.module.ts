import { Module } from '@nestjs/common';
import { TripsController } from './controllers/trips.controller';
import { TripsService } from './services/trips.service';

@Module({
  controllers: [TripsController],
  providers: [TripsService],
})
export class TripsModule {}
