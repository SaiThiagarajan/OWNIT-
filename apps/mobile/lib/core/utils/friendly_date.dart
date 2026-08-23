/// Formats a [DateTime] as a short, human-friendly label ("Today, 3:41 PM",
/// "Yesterday", "Aug 12") without pulling in the `intl` package for a
/// handful of strings.
String friendlyDate(DateTime dateTime, {bool includeTime = false}) {
  final now = DateTime.now();
  final date = DateTime(dateTime.year, dateTime.month, dateTime.day);
  final today = DateTime(now.year, now.month, now.day);
  final difference = today.difference(date).inDays;

  final day = switch (difference) {
    0 => 'Today',
    1 => 'Yesterday',
    _ => '${_month(dateTime.month)} ${dateTime.day}',
  };

  if (!includeTime) return day;
  return '$day, ${_time(dateTime)}';
}

String _time(DateTime dateTime) {
  final hour24 = dateTime.hour;
  final hour = hour24 % 12 == 0 ? 12 : hour24 % 12;
  final minute = dateTime.minute.toString().padLeft(2, '0');
  final period = hour24 < 12 ? 'AM' : 'PM';
  return '$hour:$minute $period';
}

String _month(int month) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  return months[month - 1];
}
