import 'report.dart';

/// In-memory store of reports submitted this session, so History can show
/// them. No persistence, no backend — this is a stand-in for a real
/// repository until the API exists.
class ReportStore {
  ReportStore._();

  static final List<Report> _reports = [];

  static List<Report> get all => List.unmodifiable(_reports.reversed);

  static void add(Report report) => _reports.add(report);
}
