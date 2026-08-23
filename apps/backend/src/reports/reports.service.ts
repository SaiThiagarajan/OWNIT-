import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CreateReportDto } from './dto/create-report.dto';
import { Report } from './entities/report.entity';
import { ReportStatus } from './interfaces/report.interface';

@Injectable()
export class ReportsService {
  constructor(
    @InjectRepository(Report)
    private readonly reportsRepository: Repository<Report>,
  ) {}

  findAll(): Promise<Report[]> {
    return this.reportsRepository.find();
  }

  async findOne(id: string): Promise<Report> {
    const report = await this.reportsRepository.findOneBy({ id });
    if (!report) {
      throw new NotFoundException(`Report with id "${id}" not found`);
    }
    return report;
  }

  create(dto: CreateReportDto): Promise<Report> {
    const report = this.reportsRepository.create({
      type: dto.type,
      category: dto.category,
      description: dto.description,
      image: dto.image ?? null,
      location: dto.location,
      dateTime: dto.dateTime,
      status: ReportStatus.ACTIVE,
      safekeeping: dto.safekeeping ?? null,
    });
    return this.reportsRepository.save(report);
  }
}
