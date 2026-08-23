import 'dart:typed_data';

import '../../found_report/models/found_report_draft.dart' show SafekeepingOption;

export '../../found_report/models/found_report_draft.dart' show SafekeepingOption;

enum ReportType { lost, found }

enum ReportStatus { active }

/// A submitted lost/found report. This is the local shape the UI works
/// with for now — it's kept clean and flat so it can later map directly
/// onto a NestJS API DTO without restructuring the mobile side.
class Report {
  const Report({
    required this.id,
    required this.type,
    required this.category,
    required this.description,
    required this.coarseLocation,
    required this.dateTime,
    required this.status,
    required this.createdAt,
    this.imageBytes,
    this.safekeeping,
  });

  final String id;
  final ReportType type;
  final String category;
  final String description;
  final Uint8List? imageBytes;
  final String coarseLocation;
  final DateTime dateTime;
  final ReportStatus status;
  final SafekeepingOption? safekeeping;
  final DateTime createdAt;

  String get statusLabel => switch (status) {
        ReportStatus.active => 'Active',
      };
}
