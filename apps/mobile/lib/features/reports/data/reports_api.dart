import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:http/http.dart' as http;

import '../../found_report/models/found_report_draft.dart';
import '../models/report.dart';

/// Thrown when the backend rejects the request or the network call fails,
/// so callers can show an error state instead of crashing.
class ReportsApiException implements Exception {
  ReportsApiException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Talks to the NestJS `POST /reports` endpoint.
class ReportsApi {
  ReportsApi._();

  /// Android emulators can't reach the host machine via `localhost` — that
  /// address resolves to the emulator itself, so they need the special
  /// alias `10.0.2.2`. iOS simulators, web, and desktop builds all resolve
  /// `localhost` to the host machine correctly.
  static String get _baseUrl {
    if (!kIsWeb && Platform.isAndroid) {
      return 'http://10.0.2.2:3000';
    }
    return 'http://localhost:3000';
  }

  static String _safekeepingToJson(SafekeepingOption option) => switch (option) {
        SafekeepingOption.keepingSafely => 'KEEPING_SAFELY',
        SafekeepingOption.frontDesk => 'FRONT_DESK',
        SafekeepingOption.security => 'SECURITY',
        SafekeepingOption.other => 'OTHER',
      };

  /// Submits a found-item report and returns it as stored by the backend
  /// (with its generated id and createdAt). The photo itself isn't sent —
  /// the backend doesn't support image upload yet — so the caller's local
  /// photo bytes are carried over for on-device display only.
  static Future<Report> submitFoundReport(FoundReportDraft draft) async {
    final body = <String, dynamic>{
      'type': 'FOUND',
      'category': draft.category ?? 'Other',
      'description': draft.description,
      'location': draft.locationLabel ?? 'Unknown area',
      'dateTime': (draft.occurredAt ?? DateTime.now()).toUtc().toIso8601String(),
      if (draft.safekeeping != null) 'safekeeping': _safekeepingToJson(draft.safekeeping!),
    };

    final uri = Uri.parse('$_baseUrl/reports');
    final encodedBody = jsonEncode(body);
    // TEMP DEBUG — remove after diagnosing the submission failure.
    debugPrint('[ReportsApi] POST $uri');
    debugPrint('[ReportsApi] body: $encodedBody');

    final http.Response response;
    try {
      response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: encodedBody,
          )
          .timeout(const Duration(seconds: 10));
    } catch (e, st) {
      // TEMP DEBUG — remove after diagnosing the submission failure.
      debugPrint('[ReportsApi] exception type: ${e.runtimeType}');
      debugPrint('[ReportsApi] exception message: $e');
      debugPrint('[ReportsApi] stack trace:\n$st');
      // TEMP DEBUG — rethrowing the original exception (not
      // ReportsApiException) so the real error reaches the caller while
      // we're diagnosing. Restore the ReportsApiException wrap afterward.
      rethrow;
    }

    // TEMP DEBUG — remove after diagnosing the submission failure.
    debugPrint('[ReportsApi] status: ${response.statusCode}');
    debugPrint('[ReportsApi] response body: ${response.body}');

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw ReportsApiException('Server rejected the report (${response.statusCode}).');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return Report(
      id: json['id'] as String,
      type: ReportType.found,
      category: json['category'] as String,
      description: json['description'] as String,
      imageBytes: draft.photoBytes,
      coarseLocation: json['location'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
      status: ReportStatus.active,
      safekeeping: draft.safekeeping,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
