import 'dart:typed_data';

enum SafekeepingOption { keepingSafely, frontDesk, security, other }

/// Mutable, in-memory draft for a found-item report. The category and
/// description start out as "AI suggested" values (mocked here — no real
/// AI call yet) that the user can edit before confirming.
class FoundReportDraft {
  Uint8List? photoBytes;
  String? category;
  String description = '';
  int? aiConfidence;
  bool aiSuggestionConfirmed = false;
  String? locationLabel;
  DateTime? occurredAt;
  SafekeepingOption? safekeeping;

  bool get hasPhoto => photoBytes != null;
  bool get hasLocation => locationLabel != null && locationLabel!.trim().isNotEmpty;
}
