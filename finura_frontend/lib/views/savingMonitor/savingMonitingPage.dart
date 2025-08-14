import 'package:finura_frontend/services/local_database/local_database_helper.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class SavingMonitorPage extends StatefulWidget {
  final String userId;
  const SavingMonitorPage({super.key, required this.userId});

  @override
  State<SavingMonitorPage> createState() => _SavingMonitorPageState();
}

class _SavingMonitorPageState extends State<SavingMonitorPage> {
  final dbHelper = FinuraLocalDbHelper();
  double totalSaving = 0;
  String currentMonth = DateFormat.MMMM().format(DateTime.now());
  List<Map<String, dynamic>> savingGoals = [];
  List<FlSpot> incomeData = [];
  List<FlSpot> expenseData = [];
  List<FlSpot> savingData = [];

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData({String? month}) async {
    final db = await dbHelper.database;
    final String filterMonth = month ?? currentMonth;

    // Get all saving goals
    savingGoals = await db.query(
      'saving_goal',
      where: 'user_id = ?',
      whereArgs: [widget.userId],
    );

    // Fetch income & expense entries for the month
    final incomeEntries = await db.rawQuery(
      '''
      SELECT day, SUM(income_amount) as total_income
      FROM income_entry
      WHERE user_id = ? AND strftime('%m', date) = ?
      GROUP BY day
    ''',
      [widget.userId, _monthToNumber(filterMonth)],
    );

    final expenseEntries = await db.rawQuery(
      '''
      SELECT day, SUM(expense_amount) as total_expense
      FROM expense_entry
      WHERE user_id = ? AND strftime('%m', date) = ?
      GROUP BY day
    ''',
      [widget.userId, _monthToNumber(filterMonth)],
    );

    // Build line chart data
    incomeData = incomeEntries
        .map(
          (e) => FlSpot(
            (e['day'] as int).toDouble(),
            (e['total_income'] as num?)?.toDouble() ?? 0,
          ),
        )
        .toList();

    expenseData = expenseEntries
        .map(
          (e) => FlSpot(
            (e['day'] as int).toDouble(),
            (e['total_expense'] as num?)?.toDouble() ?? 0,
          ),
        )
        .toList();

    // Calculate savings = income - expense for each day
    savingData = [];
    for (var i = 1; i <= 30; i++) {
      double income = incomeData
          .firstWhere(
            (spot) => spot.x == i.toDouble(),
            orElse: () => const FlSpot(0, 0),
          )
          .y;
      double expense = expenseData
          .firstWhere(
            (spot) => spot.x == i.toDouble(),
            orElse: () => const FlSpot(0, 0),
          )
          .y;
      savingData.add(FlSpot(i.toDouble(), income - expense));
    }

    // Total saving for the month
    totalSaving = savingData.fold(0, (sum, spot) => sum + spot.y);

    setState(() {});
  }

  String _monthToNumber(String monthName) {
    return DateFormat('MM').format(DateFormat.MMMM().parse(monthName));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saving Monitor"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top: Total Saving & Month
            Text(
              "Total Saving: \$${totalSaving.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              currentMonth,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 10),

            // Line Chart
            Expanded(
              flex: 2,
              child: LineChart(
                LineChartData(
                  minX: 1,
                  maxX: 30,
                  minY: 0,
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: incomeData,
                      isCurved: true,
                      color: Colors.green,
                      barWidth: 2,
                    ),
                    LineChartBarData(
                      spots: expenseData,
                      isCurved: true,
                      color: Colors.red,
                      barWidth: 2,
                    ),
                    LineChartBarData(
                      spots: savingData,
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 2,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Saving Goals List
            Expanded(
              flex: 2,
              child: ListView.builder(
                itemCount: savingGoals.length,
                itemBuilder: (context, index) {
                  final goal = savingGoals[index];
                  double progress = 0;
                  if (goal['target_saving'] > 0) {
                    progress = (goal['current_saved'] / goal['target_saving'])
                        .clamp(0.0, 1.0);
                  }
                  String goalMonth = DateFormat.MMMM().format(
                    DateTime.parse(goal['start_date']),
                  );

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        currentMonth = goalMonth;
                      });
                      _loadAllData(month: goalMonth);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.blue, width: 1),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Month & % Left
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                goalMonth,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${((1 - progress) * 100).toStringAsFixed(0)}% left",
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Progress Line
                          Stack(
                            children: [
                              Container(
                                height: 6,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.lightBlue.shade100,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              Container(
                                height: 6,
                                width:
                                    MediaQuery.of(context).size.width *
                                    progress,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text("Target Saving: \$${goal['target_saving']}"),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
