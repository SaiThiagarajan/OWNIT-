export enum ReportType {
  LOST = 'LOST',
  FOUND = 'FOUND',
}

export enum ReportStatus {
  ACTIVE = 'ACTIVE',
}

/**
 * Where a found item is being kept until it's claimed. Only meaningful
 * for FOUND reports; LOST reports leave this null.
 */
export enum SafekeepingOption {
  KEEPING_SAFELY = 'KEEPING_SAFELY',
  FRONT_DESK = 'FRONT_DESK',
  SECURITY = 'SECURITY',
  OTHER = 'OTHER',
}
