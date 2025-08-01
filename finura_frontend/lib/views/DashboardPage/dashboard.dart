import 'package:finura_frontend/services/local_database/local_database_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardPage extends StatefulWidget {
  final String userId;
  const DashboardPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String selectedRange = 'day';
  double totalIncome = 0;
  double totalExpense = 0;

  @override
  void initState() {
    super.initState();
    _fetchData(); // Initial fetch for 'day'
  }

  Future<void> _fetchData() async {
    final db = await FinuraLocalDbHelper().database;
    final now = DateTime.now();
    late DateTime startDate;

    if (selectedRange == 'day') {
      startDate = DateTime(now.year, now.month, now.day);
    } else if (selectedRange == 'week') {
      startDate = now.subtract(const Duration(days: 6));
    } else {
      startDate = now.subtract(const Duration(days: 29));
    }

    final start = DateFormat('yyyy-MM-dd').format(startDate);
    final end = DateFormat('yyyy-MM-dd').format(now);

    final incomeResult = await db.rawQuery(
      '''
    SELECT SUM(income_amount) as total FROM income_entry
    WHERE user_id = ? AND date BETWEEN ? AND ?
  ''',
      [widget.userId, start, end],
    );

    final expenseResult = await db.rawQuery(
      '''
    SELECT SUM(expense_amount) as total FROM expense_entry
    WHERE user_id = ? AND date BETWEEN ? AND ?
  ''',
      [widget.userId, start, end],
    );

    // 👇 Ensure state is updated *after* data is retrieved
    setState(() {
      totalIncome = (incomeResult.first['total'] ?? 0.0) as double;
      totalExpense = (expenseResult.first['total'] ?? 0.0) as double;
    });
  }

  Widget _buildPieChart() {
    final total = totalIncome + totalExpense;
    if (total == 0) {
      return const Text("No data", style: TextStyle(color: Colors.grey));
    }

    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            color: Colors.green,
            value: totalIncome,
            title: '${(totalIncome / total * 100).toStringAsFixed(1)}%',
          ),
          PieChartSectionData(
            color: Colors.red,
            value: totalExpense,
            title: '${(totalExpense / total * 100).toStringAsFixed(1)}%',
          ),
        ],
      ),
      key: ValueKey('$totalIncome-$totalExpense'), // 👈 forces redraw
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: const Color.fromARGB(255, 164, 245, 171),
      ),
      body: Container(
        color: const Color.fromARGB(255, 240, 240, 240),

        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: SizedBox(
            width: double.infinity,
            height: 260,

            child: Padding(
              padding: const EdgeInsets.all(8.0),

              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(left: 16),
                    child: SizedBox(
                      height: 25,
                      width: 200,

                      child: ToggleButtons(
                        isSelected: [
                          selectedRange == 'day',
                          selectedRange == 'week',
                          selectedRange == 'month',
                        ],
                        onPressed: (index) {
                          setState(() {
                            selectedRange = ['day', 'week', 'month'][index];
                            _fetchData();
                          });
                        },
                        children: const [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text("Day"),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text("Week"),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text("Month"),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Income and Expense
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Total Income:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                "৳ ${totalIncome.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 19,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "Total Expense:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                "৳ ${totalExpense.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                  fontSize: 19,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Pie Chart
                        Expanded(
                          flex: 1,

                          child: SizedBox(height: 150, child: _buildPieChart()),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      
        

      ),
    );
  }
}
