import { plainToInstance } from 'class-transformer';
import { validate } from 'class-validator';
import { CreateReportDto } from './create-report.dto';

const validPayload = {
  type: 'LOST',
  category: 'WALLET',
  description: 'Black leather wallet with a small scratch near the zipper',
  location: 'Central Library',
  dateTime: '2026-08-21T18:30:00.000Z',
};

describe('CreateReportDto', () => {
  it('passes validation for a valid payload', async () => {
    const dto = plainToInstance(CreateReportDto, validPayload);
    const errors = await validate(dto);

    expect(errors).toHaveLength(0);
  });

  it('rejects a type outside LOST/FOUND', async () => {
    const dto = plainToInstance(CreateReportDto, {
      ...validPayload,
      type: 'STOLEN',
    });
    const errors = await validate(dto);

    expect(errors.some((error) => error.property === 'type')).toBe(true);
  });

  it('rejects an empty category', async () => {
    const dto = plainToInstance(CreateReportDto, {
      ...validPayload,
      category: '',
    });
    const errors = await validate(dto);

    expect(errors.some((error) => error.property === 'category')).toBe(true);
  });

  it('rejects a non-ISO8601 dateTime', async () => {
    const dto = plainToInstance(CreateReportDto, {
      ...validPayload,
      dateTime: 'not-a-date',
    });
    const errors = await validate(dto);

    expect(errors.some((error) => error.property === 'dateTime')).toBe(true);
  });

  it('rejects a payload missing required fields', async () => {
    const dto = plainToInstance(CreateReportDto, { type: 'LOST' });
    const errors = await validate(dto);

    const invalidProperties = errors.map((error) => error.property);
    expect(invalidProperties).toEqual(
      expect.arrayContaining([
        'category',
        'description',
        'location',
        'dateTime',
      ]),
    );
  });
});
