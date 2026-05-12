import 'package:flutter/material.dart';
import 'package:granth/services/firestore_service.dart';

class ReadingActivityGraph extends StatefulWidget {
  const ReadingActivityGraph({super.key});

  @override
  State<ReadingActivityGraph> createState() => _ReadingActivityGraphState();
}

class _ReadingActivityGraphState extends State<ReadingActivityGraph> {
  final _firestoreService = FirestoreService();
  Map<String, int> _activity = {};
  bool _isLoading = true;

  // Show last 10 weeks (70 days)
  static const int _weeks = 10;
  static const int _days = _weeks * 7;

  @override
  void initState() {
    super.initState();
    _loadActivity();
  }

  Future<void> _loadActivity() async {
    final data = await _firestoreService.getReadingActivity();
    setState(() {
      _activity = data;
      _isLoading = false;
    });
  }

  // Generate the last _days dates as strings
  List<DateTime> get _dateRange {
    final today = DateTime.now();
    return List.generate(
      _days,
      (i) => today.subtract(Duration(days: _days - 1 - i)),
    );
  }

  String _dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  // Returns color intensity based on count
  Color _cellColor(int count) {
    if (count == 0) return Colors.black12;
    if (count == 1) return const Color(0xFFFF3F00).withOpacity(0.35);
    if (count == 2) return const Color(0xFFFF3F00).withOpacity(0.6);
    if (count == 3) return const Color(0xFFFF3F00).withOpacity(0.8);
    return const Color(0xFFFF3F00); // 4+ sessions
  }

  int get _totalSessions =>
      _activity.values.fold(0, (sum, count) => sum + count);

  int get _activeDays => _activity.values.where((c) => c > 0).length;

  int get _currentStreak {
    final today = DateTime.now();
    int streak = 0;
    for (int i = 0; i < 365; i++) {
      final date = today.subtract(Duration(days: i));
      final key = _dateKey(date);
      if ((_activity[key] ?? 0) > 0) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section label
        Container(
          // color: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: const Text(
            'READING ACTIVITY',
            style: TextStyle(
              fontFamily: 'JimNightshade',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: 2,
            ),
          ),
        ),

        const SizedBox(height: 12),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Color(0xFFF5F0E8),
            border: Border(
              top: BorderSide(color: Colors.black, width: 2),
              bottom: BorderSide(color: Colors.black, width: 2),
              left: BorderSide(color: Colors.black, width: 2),
              right: BorderSide(color: Colors.black, width: 2),
            ),
            boxShadow: [
              BoxShadow(
                  color: Colors.black, offset: Offset(4, 4), blurRadius: 0),
            ],
          ),
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.black),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stats row
                    Row(
                      children: [
                        _statChip(
                            label: 'SESSIONS', value: '$_totalSessions'),
                        const SizedBox(width: 10),
                        _statChip(label: 'DAYS', value: '$_activeDays'),
                        const SizedBox(width: 10),
                        _statChip(
                            label: 'STREAK',
                            value: '${_currentStreak}🔥',
                            highlight: _currentStreak > 0),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Day labels
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('MON',
                            style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w900,
                                color: Colors.black45,
                                letterSpacing: 1)),
                        Text('WED',
                            style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w900,
                                color: Colors.black45,
                                letterSpacing: 1)),
                        Text('FRI',
                            style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w900,
                                color: Colors.black45,
                                letterSpacing: 1)),
                        Text('SUN',
                            style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w900,
                                color: Colors.black45,
                                letterSpacing: 1)),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // Graph grid — 7 rows (days) x _weeks columns
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final cellSize =
                            (constraints.maxWidth - (_weeks - 1) * 3) /
                                _weeks;
                        final dates = _dateRange;

                        return Column(
                          children: List.generate(7, (dayIndex) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 3),
                              child: Row(
                                children: List.generate(_weeks, (weekIndex) {
                                  final index = weekIndex * 7 + dayIndex;
                                  if (index >= dates.length) {
                                    return SizedBox(
                                        width: cellSize,
                                        height: cellSize);
                                  }
                                  final date = dates[index];
                                  final key = _dateKey(date);
                                  final count = _activity[key] ?? 0;

                                  return Padding(
                                    padding: EdgeInsets.only(
                                        right: weekIndex < _weeks - 1 ? 3 : 0),
                                    child: Tooltip(
                                      message:
                                          '${date.day}/${date.month}: $count session${count != 1 ? 's' : ''}',
                                      child: Container(
                                        width: cellSize,
                                        height: cellSize,
                                        decoration: BoxDecoration(
                                          color: _cellColor(count),
                                          border: Border.all(
                                            color: Colors.black26,
                                            width: 0.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            );
                          }),
                        );
                      },
                    ),

                    const SizedBox(height: 12),

                    // Legend
                    Row(
                      children: [
                        const Text(
                          'LESS',
                          style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w900,
                              color: Colors.black45,
                              letterSpacing: 1),
                        ),
                        const SizedBox(width: 4),
                        ...List.generate(5, (i) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 3),
                            child: Container(
                              width: 10,
                              height: 10,
                              color: _cellColor(i),
                              margin: EdgeInsets.zero,
                            ),
                          );
                        }),
                        const Text(
                          'MORE',
                          style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w900,
                              color: Colors.black45,
                              letterSpacing: 1),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _statChip({
    required String label,
    required String value,
    bool highlight = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: highlight ? Colors.black : const Color(0xFFF5F0E8),
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontFamily: 'JimNightshade',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: highlight ? const Color(0xFFFF3F00) : Colors.black,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
              color: highlight ? Colors.white60 : Colors.black45,
            ),
          ),
        ],
      ),
    );
  }
}