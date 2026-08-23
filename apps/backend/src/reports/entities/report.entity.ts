import { Column, CreateDateColumn, Entity, PrimaryGeneratedColumn } from 'typeorm';
import { ReportStatus, ReportType, SafekeepingOption } from '../interfaces/report.interface';

@Entity('reports')
export class Report {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'enum', enum: ReportType })
  type: ReportType;

  @Column({ length: 100 })
  category: string;

  @Column({ type: 'text' })
  description: string;

  @Column({ type: 'text', nullable: true })
  image: string | null;

  @Column({ length: 200 })
  location: string;

  @Column({ type: 'timestamptz' })
  dateTime: string;

  @Column({ type: 'enum', enum: ReportStatus, default: ReportStatus.ACTIVE })
  status: ReportStatus;

  @Column({ type: 'enum', enum: SafekeepingOption, nullable: true })
  safekeeping: SafekeepingOption | null;

  @CreateDateColumn({ type: 'timestamptz' })
  createdAt: Date;
}
