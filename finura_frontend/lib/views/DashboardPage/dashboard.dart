import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:finura_frontend/services/local_database/local_database_helper.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<String> views = ['Day', 'Week', 'Month'];
  int selectedIndex = 0;

  double totalIncome = 0.0;
  double totalExpense = 0.0;

  List<FlSpot> incomeSpots = [];
  List<FlSpot> expenseSpots = [];

  String get selectedView => views[selectedIndex];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final db = await FinuraLocalDbHelper().database;
    final now = DateTime.now();
    final dateToday = now.toIso8601String().split('T').first;
    final year = now.year.toString();
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day;
    final weekday = now.weekday; // 1 (Mon) - 7 (Sun)

    String incomeTotalQuery = '';
    String expenseTotalQuery = '';
    List<String> args = [];

    if (selectedView == 'Day') {
      incomeTotalQuery =
          "SELECT SUM(income_amount) as total_income FROM income_entry WHERE date = ?";
      expenseTotalQuery =
          "SELECT SUM(expense_amount) as total_expense FROM expense_entry WHERE date = ?";
      args = [dateToday];

      final incomeResult = await db.rawQuery(
        'SELECT strftime("%H", time) as hour, SUM(income_amount) as total_income FROM income_entry WHERE date = ? GROUP BY hour ORDER BY hour',
        [dateToday],
      );
      final expenseResult = await db.rawQuery(
        'SELECT strftime("%H", time) as hour, SUM(expense_amount) as total_expense FROM expense_entry WHERE date = ? GROUP BY hour ORDER BY hour',
        [dateToday],
      );
      incomeSpots = incomeResult.map((row) {
        double x = double.parse(row['hour'].toString());
        double y = double.tryParse(row['total_income'].toString()) ?? 0.0;
        return FlSpot(x, y);
      }).toList();
      expenseSpots = expenseResult.map((row) {
        double x = double.parse(row['hour'].toString());
        double y = double.tryParse(row['total_expense'].toString()) ?? 0.0;
        return FlSpot(x, y);
      }).toList();
    } else if (selectedView == 'Week') {
      DateTime startOfWeek = now.subtract(Duration(days: weekday - 1));
      String start = startOfWeek.toIso8601String().split('T').first;
      String end = now.toIso8601String().split('T').first;

      incomeTotalQuery =
          "SELECT SUM(income_amount) as total_income FROM income_entry WHERE date BETWEEN ? AND ?";
      expenseTotalQuery =
          "SELECT SUM(expense_amount) as total_expense FROM expense_entry WHERE date BETWEEN ? AND ?";
      args = [start, end];

      final incomeResult = await db.rawQuery(
        'SELECT strftime("%w", date) as weekday, SUM(income_amount) as total_income FROM income_entry WHERE date BETWEEN ? AND ? GROUP BY weekday ORDER BY weekday',
        [start, end],
      );
      final expenseResult = await db.rawQuery(
        'SELECT strftime("%w", date) as weekday, SUM(expense_amount) as total_expense FROM expense_entry WHERE date BETWEEN ? AND ? GROUP BY weekday ORDER BY weekday',
        [start, end],
      );
      incomeSpots = incomeResult.map((row) {
        double x = double.parse(row['weekday'].toString());
        double y = double.tryParse(row['total_income'].toString()) ?? 0.0;
        return FlSpot(x, y);
      }).toList();
      expenseSpots = expenseResult.map((row) {
        double x = double.parse(row['weekday'].toString());
        double y = double.tryParse(row['total_expense'].toString()) ?? 0.0;
        return FlSpot(x, y);
      }).toList();
    } else {
      incomeTotalQuery =
          "SELECT SUM(income_amount) as total_income FROM income_entry WHERE strftime('%m', date) = ? AND strftime('%Y', date) = ?";
      expenseTotalQuery = incomeTotalQuery;
      args = [month, year];

      final incomeResult = await db.rawQuery(
        'SELECT ((day - 1) / 7) as week, SUM(income_amount) as total_income FROM income_entry WHERE strftime("%m", date) = ? AND strftime("%Y", date) = ? GROUP BY week ORDER BY week',
        [month, year],
      );
      final expenseResult = await db.rawQuery(
        'SELECT ((day - 1) / 7) as week, SUM(expense_amount) as total_expense FROM expense_entry WHERE strftime("%m", date) = ? AND strftime("%Y", date) = ? GROUP BY week ORDER BY week',
        [month, year],
      );
      incomeSpots = incomeResult.map((row) {
        double x = double.parse(row['week'].toString());
        double y = double.tryParse(row['total_income'].toString()) ?? 0.0;
        return FlSpot(x, y);
      }).toList();
      expenseSpots = expenseResult.map((row) {
        double x = double.parse(row['week'].toString());
        double y = double.tryParse(row['total_expense'].toString()) ?? 0.0;
        return FlSpot(x, y);
      }).toList();
    }

    final totalIncomeResult = await db.rawQuery(incomeTotalQuery, args);
    final totalExpenseResult = await db.rawQuery(expenseTotalQuery, args);

    totalIncome =
        double.tryParse(
          totalIncomeResult.first['total_income']?.toString() ?? '0',
        ) ??
        0.0;
    totalExpense =
        double.tryParse(
          totalExpenseResult.first['total_expense']?.toString() ?? '0',
        ) ??
        0.0;

    setState(() {});
  }

  Widget buildChart() {
    return LineChart(
      LineChartData(
        minY: 0,
        gridData: FlGridData(show: true, drawVerticalLine: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                if (selectedView == 'Day') {
                  return Text(
                    '${value.toInt()}h',
                    style: const TextStyle(fontSize: 10),
                  );
                } else if (selectedView == 'Week') {
                  const days = [
                    'Sun',
                    'Mon',
                    'Tue',
                    'Wed',
                    'Thu',
                    'Fri',
                    'Sat',
                  ];
                  return Text(
                    days[value.toInt() % 7],
                    style: const TextStyle(fontSize: 10),
                  );
                } else {
                  return Text(
                    'W${(value + 1).toInt()}',
                    style: const TextStyle(fontSize: 10),
                  );
                }
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            spots: incomeSpots,
            color: Colors.green,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.green.withOpacity(0.3),
            ),
            barWidth: 3,
          ),
          LineChartBarData(
            isCurved: true,
            spots: expenseSpots,
            color: Colors.red,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.red.withOpacity(0.2),
            ),
            barWidth: 3,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Deshboard")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total according to"),
                ToggleButtons(
                  borderRadius: BorderRadius.circular(12),
                  selectedColor: Colors.white,
                  fillColor: Theme.of(context).primaryColor,
                  color: Colors.black,
                  isSelected: List.generate(3, (i) => i == selectedIndex),
                  onPressed: (index) {
                    setState(() => selectedIndex = index);
                    _fetchData();
                  },
                  children: views
                      .map(
                        (v) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(v),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
            const SizedBox(height: 10),
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
                    value: totalIncome / (totalIncome + totalExpense + 1),
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
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: buildChart(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
