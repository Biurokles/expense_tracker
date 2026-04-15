import 'package:expense_tracker/data/models/time_range.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _timeRangeKey = 'time_range';

final timeRangeProvider = StateNotifierProvider<TimeRangeNotifier, TimeRange>(
  (ref) => TimeRangeNotifier(),
);

class TimeRangeNotifier extends StateNotifier<TimeRange> {
  TimeRangeNotifier() : super(TimeRange.day) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_timeRangeKey);

    if (value != null) {
      state = TimeRange.values.firstWhere(
        (e) => e.name == value,
        orElse: () => TimeRange.day,
      );
    }
  }

  Future<void> setRange(TimeRange range) async {
    state = range;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_timeRangeKey, range.name);
  }
}
