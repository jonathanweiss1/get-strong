
/// Returns a DateTime object that only contains information on the current Year, Month and Day
DateTime currentDate() {
  final DateTime now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}