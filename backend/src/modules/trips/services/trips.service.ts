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
      icon_name: 'palmtree',
      color_value: 0xFF008080, // Teal
    },
    {
      id: '2',
      title: '東京櫻花季之旅',
      location: '日本, 東京',
      startDate: '2026-03-25T00:00:00Z',
      endDate: '2026-03-30T00:00:00Z',
      memberCount: 4,
      icon_name: 'flower2',
      color_value: 0xFFE91E63, // Pink
    },
    {
      id: '3',
      title: '瑞士阿爾卑斯山健行',
      location: '瑞士, 策馬特',
      startDate: '2026-07-15T00:00:00Z',
      endDate: '2026-07-25T00:00:00Z',
      memberCount: 2,
      icon_name: 'mountain',
      color_value: 0xFF2196F3, // Blue
    }
  ];

  private activities = [
    {
      id: 'a1',
      trip_id: '1',
      time: '06:00',
      title: '洛杉磯國際機場 (LAX)',
      subtitle: '抵達大廳，準備取車',
      type: 'FLIGHT',
      icon_name: 'plane-landing',
      personal_info: {
        '航班編號': 'BR12',
        '航空公司': '長榮航空',
        '航廈': 'Tom Bradley (TBIT)',
        '抵達時間': '06:00 AM',
      },
    },
    {
      id: 'a2',
      trip_id: '1',
      time: '08:00',
      title: '現存最古老的麥當勞',
      subtitle: '位於 Downey 的經典旗艦店',
      type: 'FOOD',
      icon_name: 'utensils',
    },
    {
      id: 'a3',
      trip_id: '1',
      time: '10:30',
      title: '格里菲斯天文台',
      subtitle: '俯瞰洛杉磯全景',
      type: 'ATTRACTION',
      icon_name: 'mountain',
    }
  ];

  async findAll() {
    return this.trips;
  }

  async findActivitiesByTripId(tripId: string) {
    return this.activities.filter(a => a.trip_id === tripId);
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
