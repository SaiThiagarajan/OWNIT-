const List<String> kSearchCategories = [
  'Electronics',
  'Bag',
  'Wallet / ID',
  'Keys',
  'Jewelry',
  'Clothing',
  'Other',
];

const List<String> kSearchLocations = [
  'Near me',
  'Central Library',
  'Campus area',
  'Downtown',
];

const List<String> kSearchDateRanges = ['Today', 'Yesterday', 'This week', 'This month'];

/// Immutable filter selection for the Search screen's filter sheet.
class SearchFilters {
  const SearchFilters({this.category, this.location, this.dateRange});

  final String? category;
  final String? location;
  final String? dateRange;

  bool get isEmpty => category == null && location == null && dateRange == null;

  int get activeCount => [category, location, dateRange].whereType<String>().length;

  SearchFilters copyWith({
    String? category,
    bool clearCategory = false,
    String? location,
    bool clearLocation = false,
    String? dateRange,
    bool clearDateRange = false,
  }) {
    return SearchFilters(
      category: clearCategory ? null : (category ?? this.category),
      location: clearLocation ? null : (location ?? this.location),
      dateRange: clearDateRange ? null : (dateRange ?? this.dateRange),
    );
  }

  static const empty = SearchFilters();
}
