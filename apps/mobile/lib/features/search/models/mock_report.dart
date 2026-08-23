import 'package:flutter/material.dart';

import '../../../core/widgets/status_badge.dart';

enum ReportKind { lost, found }

/// A public-facing lost/found listing, as shown in Search results. Only
/// coarse location and no contact details — this is what's safe to show
/// before ownership verification.
class MockReport {
  const MockReport({
    required this.id,
    required this.title,
    required this.kind,
    required this.category,
    required this.coarseLocation,
    required this.relativeTime,
    required this.icon,
    this.aiConfidence,
  });

  final String id;
  final String title;
  final ReportKind kind;
  final String category;
  final String coarseLocation;
  final String relativeTime;
  final IconData icon;
  final int? aiConfidence;

  StatusBadgeVariant get statusVariant =>
      kind == ReportKind.lost ? StatusBadgeVariant.lost : StatusBadgeVariant.found;

  String get statusLabel => kind == ReportKind.lost ? 'LOST' : 'FOUND';

  String get subtitle => kind == ReportKind.lost
      ? 'Lost near $coarseLocation'
      : 'Found near $coarseLocation';
}

const List<MockReport> kMockReports = [
  MockReport(
    id: 'r1',
    title: 'Black leather wallet',
    kind: ReportKind.found,
    category: 'Wallet / ID',
    coarseLocation: 'Central Library',
    relativeTime: 'Yesterday',
    icon: Icons.badge_outlined,
    aiConfidence: 92,
  ),
  MockReport(
    id: 'r2',
    title: 'Black wallet',
    kind: ReportKind.lost,
    category: 'Wallet / ID',
    coarseLocation: 'Downtown',
    relativeTime: '2 days ago',
    icon: Icons.badge_outlined,
  ),
  MockReport(
    id: 'r3',
    title: 'White AirPods case',
    kind: ReportKind.found,
    category: 'Electronics',
    coarseLocation: 'Campus area',
    relativeTime: '3 hours ago',
    icon: Icons.devices_other_outlined,
    aiConfidence: 78,
  ),
  MockReport(
    id: 'r4',
    title: 'Navy blue backpack',
    kind: ReportKind.lost,
    category: 'Bag',
    coarseLocation: 'Central Library',
    relativeTime: 'Today',
    icon: Icons.backpack_outlined,
  ),
  MockReport(
    id: 'r5',
    title: 'Bunch of house keys',
    kind: ReportKind.found,
    category: 'Keys',
    coarseLocation: 'Near me',
    relativeTime: 'This week',
    icon: Icons.key_outlined,
  ),
];

/// Naive local filtering over the mock dataset — a stand-in for a real
/// search API. Matches on title or category, then narrows by kind.
List<MockReport> searchMockReports(String query, {ReportKind? kind}) {
  final normalized = query.trim().toLowerCase();
  return kMockReports.where((report) {
    final matchesQuery = normalized.isEmpty ||
        report.title.toLowerCase().contains(normalized) ||
        report.category.toLowerCase().contains(normalized);
    final matchesKind = kind == null || report.kind == kind;
    return matchesQuery && matchesKind;
  }).toList();
}
