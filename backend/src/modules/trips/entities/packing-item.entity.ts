import { Entity, Column, PrimaryGeneratedColumn, CreateDateColumn, UpdateDateColumn } from 'typeorm';

/**
 * @file packing-item.entity.ts
 * @description 行李項目實體 / Packing Item Entity
 * @description_zh 定義行李清單的項目，包含類別與是否為自定義
 * @description_en Defines packing list items, including category and custom status
 */

@Entity('packing_items')
export class PackingItem {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ length: 100 })
  title: string;

  @Column({ length: 100 })
  category: string;

  @Column({ default: false })
  is_custom: boolean;

  @Column({ type: 'int', default: 0 })
  sort_order: number;

  @Column({ length: 100, nullable: true })
  created_by: string; // 使用者 ID，如果是系統預設則為 null

  @Column({ type: 'uuid', nullable: true })
  trip_id: string; // 關聯行程，如果是全域預設則為 null

  @CreateDateColumn()
  created_at: Date;

  @UpdateDateColumn()
  updated_at: Date;
}
