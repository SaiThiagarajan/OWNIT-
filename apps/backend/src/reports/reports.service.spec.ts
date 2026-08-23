import { NotFoundException } from '@nestjs/common';
import { CreateReportDto } from './dto/create-report.dto';
import { Report } from './entities/report.entity';
import { ReportStatus, ReportType } from './interfaces/report.interface';
import { ReportsService } from './reports.service';

function makeDto(overrides: Partial<CreateReportDto> = {}): CreateReportDto {
  const dto = new CreateReportDto();
  dto.type = ReportType.LOST;
  dto.category = 'WALLET';
  dto.description = 'Black leather wallet with a small scratch near the zipper';
  dto.location = 'Central Library';
  dto.dateTime = '2026-08-21T18:30:00.000Z';
  return Object.assign(dto, overrides);
}

/**
 * A minimal stand-in for TypeORM's Repository<Report>, backed by a plain
 * array, so these tests exercise ReportsService's logic without a real
 * database connection.
 */
class FakeReportsRepository {
  private readonly rows: Report[] = [];
  private nextId = 1;

  find(): Promise<Report[]> {
    return Promise.resolve(this.rows);
  }

  findOneBy({ id }: { id: string }): Promise<Report | null> {
    return Promise.resolve(this.rows.find((r) => r.id === id) ?? null);
  }

  create(partial: Partial<Report>): Report {
    return {
      id: `fake-id-${this.nextId++}`,
      createdAt: new Date(),
      ...partial,
    } as Report;
  }

  save(report: Report): Promise<Report> {
    this.rows.push(report);
    return Promise.resolve(report);
  }
}

describe('ReportsService', () => {
  let service: ReportsService;

  beforeEach(() => {
    service = new ReportsService(new FakeReportsRepository() as any);
  });

  describe('findAll', () => {
    it('returns an empty array when no reports exist', async () => {
      expect(await service.findAll()).toEqual([]);
    });

    it('returns every created report', async () => {
      await service.create(makeDto());
      await service.create(makeDto({ type: ReportType.FOUND }));

      expect(await service.findAll()).toHaveLength(2);
    });
  });

  describe('create', () => {
    it('creates a report with a generated id, ACTIVE status, and createdAt', async () => {
      const report = await service.create(makeDto());

      expect(report.id).toEqual(expect.any(String));
      expect(report.id).not.toHaveLength(0);
      expect(report.status).toBe(ReportStatus.ACTIVE);
      expect(report.createdAt).toBeInstanceOf(Date);
    });

    it('carries the submitted fields through unchanged', async () => {
      const dto = makeDto({ category: 'KEYS', location: 'Downtown' });
      const report = await service.create(dto);

      expect(report.type).toBe(dto.type);
      expect(report.category).toBe('KEYS');
      expect(report.description).toBe(dto.description);
      expect(report.location).toBe('Downtown');
      expect(report.dateTime).toBe(dto.dateTime);
    });

    it('assigns a distinct id to each report', async () => {
      const first = await service.create(makeDto());
      const second = await service.create(makeDto());

      expect(first.id).not.toBe(second.id);
    });
  });

  describe('findOne', () => {
    it('returns the matching report by id', async () => {
      const created = await service.create(makeDto());

      expect(await service.findOne(created.id)).toEqual(created);
    });

    it('throws NotFoundException for an id that does not exist', async () => {
      await expect(service.findOne('does-not-exist')).rejects.toThrow(
        NotFoundException,
      );
    });
  });
});
