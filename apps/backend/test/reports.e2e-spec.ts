import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import request from 'supertest';
import { App } from 'supertest/types';
import { AppModule } from './../src/app.module';
import { Report } from './../src/reports/interfaces/report.interface';

describe('Reports (e2e)', () => {
  let app: INestApplication<App>;

  beforeEach(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();
    app.useGlobalPipes(
      new ValidationPipe({
        whitelist: true,
        forbidNonWhitelisted: true,
        transform: true,
      }),
    );
    await app.init();
  });

  afterEach(async () => {
    await app.close();
  });

  const validReport = {
    type: 'LOST',
    category: 'WALLET',
    description: 'Black leather wallet with a small scratch near the zipper',
    location: 'Central Library',
    dateTime: '2026-08-21T18:30:00.000Z',
  };

  it('GET /health returns status ok', () => {
    return request(app.getHttpServer())
      .get('/health')
      .expect(200)
      .expect({ status: 'ok' });
  });

  it('GET /reports returns an empty array before any report exists', () => {
    return request(app.getHttpServer()).get('/reports').expect(200).expect([]);
  });

  it('POST /reports creates a report and returns it', async () => {
    const response = await request(app.getHttpServer())
      .post('/reports')
      .send(validReport)
      .expect(201);

    expect(response.body).toMatchObject({
      type: 'LOST',
      category: 'WALLET',
      description: validReport.description,
      location: 'Central Library',
      dateTime: validReport.dateTime,
      status: 'ACTIVE',
    });
    const body = response.body as Report;
    expect(body.id).toEqual(expect.any(String));
    expect(body.createdAt).toEqual(expect.any(String));
  });

  it('POST /reports rejects an invalid type with 400', () => {
    return request(app.getHttpServer())
      .post('/reports')
      .send({ ...validReport, type: 'STOLEN' })
      .expect(400);
  });

  it('POST /reports rejects a missing field with 400', () => {
    return request(app.getHttpServer())
      .post('/reports')
      .send({ type: 'LOST' })
      .expect(400);
  });

  it('GET /reports/:id returns the created report', async () => {
    const created = await request(app.getHttpServer())
      .post('/reports')
      .send(validReport);
    const createdReport = created.body as Report;

    return request(app.getHttpServer())
      .get(`/reports/${createdReport.id}`)
      .expect(200)
      .expect(createdReport);
  });

  it('GET /reports/:id returns 404 for a missing report', () => {
    return request(app.getHttpServer())
      .get('/reports/does-not-exist')
      .expect(404);
  });
});
