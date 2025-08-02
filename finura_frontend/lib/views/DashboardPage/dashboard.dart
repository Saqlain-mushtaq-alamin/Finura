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
  List<FlSpot> dayIncomeSpots = [];
  List<FlSpot> dayExpenseSpots = [];
  List<FlSpot> weekIncomeSpots = [];
  List<FlSpot> weekExpenseSpots = [];
  List<FlSpot> monthIncomeSpots = [];
  List<FlSpot> monthExpenseSpots = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final db = await FinuraLocalDbHelper().database;
    final now = DateTime.now();

    DateTime getStartDate(int daysAgo) => now.subtract(Duration(days: daysAgo));

    final dateFormat = DateFormat('yyyy-MM-dd');
    final today = dateFormat.format(now);
    final startDay = dateFormat.format(getStartDate(1));
    final startWeek = dateFormat.format(getStartDate(6));
    final startMonth = dateFormat.format(getStartDate(29));

    final ranges = {'day': startDay, 'week': startWeek, 'month': startMonth};

    final incomeResult = await db.rawQuery(
      'SELECT SUM(income_amount) as total FROM income_entry WHERE user_id = ? AND date BETWEEN ? AND ?',
      [widget.userId, ranges[selectedRange], today],
    );

    final expenseResult = await db.rawQuery(
      'SELECT SUM(expense_amount) as total FROM expense_entry WHERE user_id = ? AND date BETWEEN ? AND ?',
      [widget.userId, ranges[selectedRange], today],
    );

    setState(() {
      totalIncome = ((incomeResult.first['total'] ?? 0) as num).toDouble();
      totalExpense = ((expenseResult.first['total'] ?? 0) as num).toDouble();
    });

    await _fetchLineChartData();
  }

  Future<void> _fetchLineChartData() async {
    final db = await FinuraLocalDbHelper().database;
    final now = DateTime.now();
    final dateFormat = DateFormat('yyyy-MM-dd');

    List<FlSpot> generateSpots(
      List<Map<String, Object?>> rows,
      int length,
      String field,
    ) {
      return List.generate(length, (i) {
        double value =
            double.tryParse(
              rows
                  .firstWhere(
                    (e) => e['x'] == i.toString(),
                    orElse: () => {field: 0},
                  )[field]
                  .toString(),
            ) ??
            0.0;
        return FlSpot(i.toDouble(), value);
      });
    }

    final dayQuery = '''
      SELECT strftime('%H', date || ' 00:00:00') as x, SUM(income_amount) as income, SUM(expense_amount) as expense
      FROM (
        SELECT date, income_amount, 0 as expense_amount FROM income_entry WHERE user_id = ?
        UNION ALL
        SELECT date, 0 as income_amount, expense_amount FROM expense_entry WHERE user_id = ?
      )
      WHERE date = ?
      GROUP BY x
    ''';

    final weekQuery = '''
      SELECT strftime('%w', date || ' 00:00:00') as x, SUM(income_amount) as income, SUM(expense_amount) as expense
      FROM (
        SELECT date, income_amount, 0 as expense_amount FROM income_entry WHERE user_id = ?
        UNION ALL
        SELECT date, 0 as income_amount, expense_amount FROM expense_entry WHERE user_id = ?
      )
      WHERE date >= ?
      GROUP BY x
    ''';

    final monthQuery = '''
      SELECT ((julianday(date) - julianday(?)) / 7) as x, SUM(income_amount) as income, SUM(expense_amount) as expense
      FROM (
        SELECT date, income_amount, 0 as expense_amount FROM income_entry WHERE user_id = ?
        UNION ALL
        SELECT date, 0 as income_amount, expense_amount FROM expense_entry WHERE user_id = ?
      )
      WHERE date >= ?
      GROUP BY x
    ''';

    final todayStr = dateFormat.format(now);
    final weekStartStr = dateFormat.format(
      now.subtract(const Duration(days: 6)),
    );
    final monthStartStr = dateFormat.format(
      now.subtract(const Duration(days: 29)),
    );

    final dayResult = await db.rawQuery(dayQuery, [
      widget.userId,
      widget.userId,
      todayStr,
    ]);
    final weekResult = await db.rawQuery(weekQuery, [
      widget.userId,
      widget.userId,
      weekStartStr,
    ]);
    final monthResult = await db.rawQuery(monthQuery, [
      monthStartStr,
      widget.userId,
      widget.userId,
      monthStartStr,
    ]);

    setState(() {
      dayIncomeSpots = generateSpots(dayResult, 24, 'income');
      dayExpenseSpots = generateSpots(dayResult, 24, 'expense');
      weekIncomeSpots = generateSpots(weekResult, 7, 'income');
      weekExpenseSpots = generateSpots(weekResult, 7, 'expense');
      monthIncomeSpots = generateSpots(monthResult, 4, 'income');
      monthExpenseSpots = generateSpots(monthResult, 4, 'expense');
    });
  }

  Widget _buildPieChart() {
    final total = totalIncome + totalExpense;
    final incomePercent = total > 0 ? (totalIncome / total) * 100 : 0;
    final expensePercent = total > 0 ? (totalExpense / total) * 100 : 0;

    return SizedBox(
      height: 150,
      width: double.infinity,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: incomePercent.toDouble(),
              color: Colors.green,
              title: "${incomePercent.toStringAsFixed(1)}%",
              radius: 50,
              titleStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            PieChartSectionData(
              value: expensePercent.toDouble(),
              color: Colors.red,
              title: "${expensePercent.toStringAsFixed(1)}%",
              radius: 50,
              titleStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
          centerSpaceRadius: 30,
          sectionsSpace: 2,
        ),
      ),
    );
  }

  Widget _buildLineChart(
    List<FlSpot> incomeSpots,
    List<FlSpot> expenseSpots,
    String label,
    int rangeLength,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: 300,
            height: 200,
            child: LineChart(
              LineChartData(
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 30),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 30),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: incomeSpots,
                    color: Colors.green,
                    isCurved: true,
                    dotData: FlDotData(show: false),
                  ),
                  LineChartBarData(
                    spots: expenseSpots,
                    color: Colors.red,
                    isCurved: true,
                    dotData: FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: const Color.fromARGB(255, 164, 245, 171),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            ToggleButtons(
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
              children: const [Text("Day"), Text("Week"), Text("Month")],
            ),
            const SizedBox(height: 20),
            Text(
              "Total Income: ৳ ${totalIncome.toStringAsFixed(2)}",
              style: const TextStyle(color: Colors.green, fontSize: 18),
            ),
            Text(
              "Total Expense: ৳ ${totalExpense.toStringAsFixed(2)}",
              style: const TextStyle(color: Colors.red, fontSize: 18),
            ),
            const SizedBox(height: 20),
            _buildPieChart(),
            const SizedBox(height: 20),
            const Text(
              "Income vs Expense Over Time",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 240,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildLineChart(dayIncomeSpots, dayExpenseSpots, "Day", 24),
                    _buildLineChart(
                      weekIncomeSpots,
                      weekExpenseSpots,
                      "Week",
                      7,
                    ),
                    _buildLineChart(
                      monthIncomeSpots,
                      monthExpenseSpots,
                      "Month",
                      4,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
