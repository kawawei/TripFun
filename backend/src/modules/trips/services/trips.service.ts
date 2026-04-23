import { Injectable } from '@nestjs/common';

@Injectable()
export class TripsService {
  private trips = [
    {
      id: '1',
      title: '洛杉磯公路旅行',
      location: '美國, 加州',
      startDate: '2026-04-25T00:00:00Z',
      endDate: '2026-04-29T00:00:00Z',
      memberCount: 2,
    },
    {
      id: '2',
      title: '東京櫻花季之旅',
      location: '日本, 東京',
      startDate: '2026-03-25T00:00:00Z',
      endDate: '2026-03-30T00:00:00Z',
      memberCount: 4,
    }
  ];

  async findAll() {
    return this.trips;
  }

  async create(trip: any) {
    const newTrip = {
      ...trip,
      id: Math.random().toString(36).substring(7),
    };
    this.trips.push(newTrip);
    return newTrip;
  }
}
