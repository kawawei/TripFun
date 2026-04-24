import { Entity, Column, PrimaryGeneratedColumn, UpdateDateColumn } from 'typeorm';

/**
 * @file user-packing-status.entity.ts
 * @description 使用者行李核取狀態實體 / User Packing Status Entity
 * @description_zh 記錄每個使用者針對特定行李項目的勾選狀態
 * @description_en Records the check status of each user for specific packing items
 */

@Entity('user_packing_status')
export class UserPackingStatus {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ length: 100 })
  user_id: string;

  @Column({ type: 'uuid' })
  item_id: string;

  @Column({ type: 'uuid', nullable: true })
  trip_id: string;

  @Column({ default: false })
  is_checked: boolean;

  @UpdateDateColumn()
  updated_at: Date;
}
