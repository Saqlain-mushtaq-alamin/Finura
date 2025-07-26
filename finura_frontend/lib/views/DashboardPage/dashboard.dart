import 'package:finura_frontend/services/local_database/local_database_helper.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String selectedView = 'Day'; // or 'Month'
  double totalIncome = 0.0;
  double totalExpense = 0.0;
  List<FlSpot> chartData = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final db = await FinuraLocalDbHelper().database;
    final now = DateTime.now();
    final day = now.day;
    final month = now.month;
    final year = now.year;

    String whereClause;
    List<String> whereArgs;

    if (selectedView == 'Day') {
      whereClause = 'date = ?';
      whereArgs = [
        '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}',
      ];
    } else {
      whereClause = 'strftime("%m", date) = ? AND strftime("%Y", date) = ?';
      whereArgs = [month.toString().padLeft(2, '0'), year.toString()];
    }

    final incomeResult = await db.rawQuery(
      'SELECT SUM(income_amount) as total FROM income_entry WHERE $whereClause',
      whereArgs,
    );

    final expenseResult = await db.rawQuery(
      'SELECT SUM(expense_amount) as total FROM expense_entry WHERE $whereClause',
      whereArgs,
    );

    setState(() {
      totalIncome = incomeResult.first['total'] != null
          ? (incomeResult.first['total'] as double)
          : 0.0;
      totalExpense = expenseResult.first['total'] != null
          ? (expenseResult.first['total'] as double)
          : 0.0;

      // For chart: dummy data (replace with actual grouped data)
      chartData = List.generate(
        7,
        (i) => FlSpot(i.toDouble(), (i * 10).toDouble()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Deshboard")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Selection Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total according to"),
                DropdownButton<String>(
                  value: selectedView,
                  items: ['Day', 'Month'].map((view) {
                    return DropdownMenuItem(value: view, child: Text(view));
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedView = value;
                      });
                      _fetchData();
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Income/Expense Summary
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Income: \$${totalIncome.toStringAsFixed(2)}",
                    style: const TextStyle(color: Colors.green, fontSize: 16),
                  ),
                  LinearProgressIndicator(
                    value:
                        totalIncome /
                        (totalIncome + totalExpense + 1), // +1 to avoid /0
                    backgroundColor: Colors.green.shade100,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Expense: \$${totalExpense.toStringAsFixed(2)}",
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                  LinearProgressIndicator(
                    value: totalExpense / (totalIncome + totalExpense + 1),
                    backgroundColor: Colors.red.shade100,
                    color: Colors.red,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Line Chart
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: LineChart(
                  LineChartData(
                    titlesData: FlTitlesData(show: true),
                    lineBarsData: [
                      LineChartBarData(
                        isCurved: true,
                        spots: chartData,
                        color: Colors.blue[200],
                        barWidth: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
