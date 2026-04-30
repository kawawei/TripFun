import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Expense } from '../entities/expense.entity';

/**
 * @file accounting.service.ts
 * @description 記帳管理服務 / Accounting Management Service
 * @description_zh 負責支出分錄的 CRUD 操作，對接 PostgreSQL 資料庫
 * @description_en Handles CRUD operations for expense entries, connecting to PostgreSQL
 */

@Injectable()
export class AccountingService {
  constructor(
    @InjectRepository(Expense)
    private readonly expenseRepository: Repository<Expense>,
  ) {}

  async findAllByTripId(trip_id: string): Promise<Expense[]> {
    return this.expenseRepository.find({
      where: { trip_id },
      order: { date_time: 'DESC' },
    });
  }

  async create(expenseData: Partial<Expense>): Promise<Expense> {
    const expense = this.expenseRepository.create(expenseData);
    return this.expenseRepository.save(expense);
  }

  async sync(expenses: Partial<Expense>[]): Promise<Expense[]> {
    const results: Expense[] = [];
    for (const data of expenses) {
      if (data.id) {
        // 嘗試更新或建立 (Upsert)
        const existing = await this.expenseRepository.findOne({ where: { id: data.id } });
        if (existing) {
          await this.expenseRepository.update(data.id, data);
          results.push(await this.expenseRepository.findOne({ where: { id: data.id } }));
        } else {
          const newExpense = this.expenseRepository.create(data);
          results.push(await this.expenseRepository.save(newExpense));
        }
      } else {
        const newExpense = this.expenseRepository.create(data);
        results.push(await this.expenseRepository.save(newExpense));
      }
    }
    return results;
  }

  async remove(id: string): Promise<void> {
    await this.expenseRepository.delete(id);
  }
}
