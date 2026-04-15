enum TimeRange {
  day,
  month,
  year,
}

extension TimeRangeX on TimeRange {
  bool matches(DateTime date) {
    final now = DateTime.now();

    switch (this) {
      case TimeRange.day:
        return date.year == now.year &&
            date.month == now.month &&
            date.day == now.day;

      case TimeRange.month:
        return date.year == now.year && date.month == now.month;

      case TimeRange.year:
        return date.year == now.year;
    }
  }

  int showDate() {
    final now = DateTime.now();
    switch (this) {
      case TimeRange.day:
        return now.day;
      case TimeRange.month:
        return now.month;
      case TimeRange.year:
        return now.year;
    }
  }

  String emptyChartMessage() {
    switch (this) {
      case TimeRange.day:
        return "Łiła! Dzisiaj jeszcze nic nie kupiłaś! Jakby girl!";
      case TimeRange.month:
        return "Najwyraźniej nie przyszła jeszcze wypłata";
      case TimeRange.year:
        return "Uuu to chyba nowy rok, że tak nic nie kupujesz";
    }
  }

  String rangeText() {
    switch (this) {
      case TimeRange.day:
        return 'Dzisiaj';
      case TimeRange.month:
        return 'W tym miesiącu';
      case TimeRange.year:
        return 'W tym roku';
    }
  }
}
