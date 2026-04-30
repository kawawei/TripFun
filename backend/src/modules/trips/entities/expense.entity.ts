import { Entity, Column, PrimaryGeneratedColumn, CreateDateColumn, UpdateDateColumn, Index } from 'typeorm';

/**
 * @file expense.entity.ts
 * @description 記帳實體 / Expense Entity
 * @description_zh 定義記帳分錄在資料庫中的表結構
 * @description_en Defines the table structure for expense entries in the database
 */

@Entity('expenses')
export class Expense {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Index()
  @Column({ type: 'uuid' })
  trip_id: string;

  @Column({ length: 100 })
  title: string;

  @Column({ type: 'decimal', precision: 15, scale: 2 })
  amount: number;

  @Column({ length: 10 })
  currency: string;

  @Column({ type: 'decimal', precision: 15, scale: 2 })
  amount_in_base_currency: number;

  @Column({ length: 50 })
  category: string;

  @Column({ type: 'text', nullable: true })
  note: string;

  @Column({ type: 'timestamp' })
  date_time: Date;

  @Column({ length: 50, nullable: true })
  user_id: string;

  @CreateDateColumn()
  created_at: Date;

  @UpdateDateColumn()
  updated_at: Date;
}
