import {
  IsEnum,
  IsISO8601,
  IsNotEmpty,
  IsOptional,
  IsString,
  MaxLength,
} from 'class-validator';
import { ReportType, SafekeepingOption } from '../interfaces/report.interface';

export class CreateReportDto {
  @IsEnum(ReportType, {
    message: `type must be one of: ${Object.values(ReportType).join(', ')}`,
  })
  type: ReportType;

  @IsString()
  @IsNotEmpty()
  @MaxLength(100)
  category: string;

  @IsString()
  @IsNotEmpty()
  @MaxLength(1000)
  description: string;

  @IsString()
  @IsNotEmpty()
  @MaxLength(200)
  location: string;

  @IsISO8601()
  dateTime: string;

  @IsOptional()
  @IsString()
  image?: string;

  @IsOptional()
  @IsEnum(SafekeepingOption, {
    message: `safekeeping must be one of: ${Object.values(SafekeepingOption).join(', ')}`,
  })
  safekeeping?: SafekeepingOption;
}
