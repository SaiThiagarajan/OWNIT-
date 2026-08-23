import 'dart:typed_data';

/// Mutable, in-memory draft for a lost-item report. Nothing here is
/// persisted or sent anywhere yet — it only lives for the duration of the
/// [LostReportFlowScreen] session.
class LostReportDraft {
  String? category;
  Uint8List? photoBytes;
  String description = '';
  String? locationLabel;
  DateTime? occurredAt;

  bool get hasCategory => category != null;
  bool get hasDescription => description.trim().isNotEmpty;
  bool get hasLocation => locationLabel != null && locationLabel!.trim().isNotEmpty;
}
