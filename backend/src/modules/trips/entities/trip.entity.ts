import { Entity, Column, PrimaryGeneratedColumn, CreateDateColumn, UpdateDateColumn } from 'typeorm';

/**
 * @file trip.entity.ts
 * @description 行程實體 / Trip Entity
 * @description_zh 定義行程在資料庫中的表結構
 * @description_en Defines the table structure for trips in the database
 */

@Entity('trips')
export class Trip {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ length: 100 })
  title: string;

  @Column({ length: 255, nullable: true })
  location: string;

  @Column({ type: 'timestamp' })
  startDate: Date;

  @Column({ type: 'timestamp' })
  endDate: Date;

  @Column({ default: 1 })
  memberCount: number;

  @Column({ type: 'uuid', unique: true, default: () => 'uuid_generate_v4()' })
  share_token: string;

  @Column({ length: 50, nullable: true })
  icon_name: string;

  @Column({ type: 'bigint', nullable: true })
  color_value: number;

  @Column({ length: 50, nullable: true })
  owner_id: string;

  @Column({ length: 20, default: 'ACTIVE' })
  status: string;

  @CreateDateColumn()
  created_at: Date;

  @UpdateDateColumn()
  updated_at: Date;
}
