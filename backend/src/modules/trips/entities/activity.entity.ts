import { Entity, Column, PrimaryGeneratedColumn, CreateDateColumn, UpdateDateColumn, ManyToOne, JoinColumn } from 'typeorm';
import { Trip } from './trip.entity';

/**
 * @file activity.entity.ts
 * @description 活動實體 / Activity Entity
 * @description_zh 定義行程內每一項活動的詳細表結構
 * @description_en Defines the table structure for every activity within a trip
 */

@Entity('activities')
export class Activity {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'uuid' })
  trip_id: string;

  @ManyToOne(() => Trip, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'trip_id' })
  trip: Trip;

  @Column({ length: 20 })
  time: string;

  @Column({ length: 100 })
  title: string;

  @Column({ length: 255, nullable: true })
  subtitle: string;

  @Column({ type: 'text', nullable: true })
  content: string;

  @Column({ length: 30 })
  type: string;

  @Column({ length: 50, nullable: true })
  icon_name: string;

  @Column({ type: 'jsonb', nullable: true })
  personal_info: any;

  @Column({ default: 0 })
  sort_order: number;

  @Column({ length: 255, nullable: true })
  location_name: string;

  @Column({ type: 'decimal', precision: 10, scale: 8, nullable: true })
  latitude: number;

  @Column({ type: 'decimal', precision: 11, scale: 8, nullable: true })
  longitude: number;

  @Column({ type: 'text', nullable: true })
  image_url: string;

  @CreateDateColumn()
  created_at: Date;

  @UpdateDateColumn()
  updated_at: Date;
}
