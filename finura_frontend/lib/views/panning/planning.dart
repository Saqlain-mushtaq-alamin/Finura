 import 'package:finura_frontend/services/local_database/local_database_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class PlanningPage extends StatefulWidget {
  
  
  final String userId;
  
  final dynamic db;

  const PlanningPage({super.key, required this. db, required this.userId});

  @override
  // ignore: library_private_types_in_public_api
  _PlanningPageState createState() => _PlanningPageState();
}

class _PlanningPageState extends State<PlanningPage> {
  String selectedMonth = DateFormat('MMMM yyyy').format(DateTime.now());
  final TextEditingController incomeController = TextEditingController();
  final TextEditingController savingController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  

  double expenseLimit = 0.0;

  // Month selection
  void _selectMonth(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 2),
      helpText: "Select Month",
    );

    if (picked != null) {
      setState(() {
        selectedMonth = DateFormat('MMMM yyyy').format(picked);
      });
    }
  }

  // Insert into DB
  Future<void> _submitGoal() async {
     final db = await FinuraLocalDbHelper().database;

    if (incomeController.text.isEmpty || savingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields.")),
      );
      return;
    }


    final monthlyIncome = double.tryParse(incomeController.text) ?? 0;
    final targetSaving = double.tryParse(savingController.text) ?? 0;
    final description = descriptionController.text;

    // Calculate expense limit
    expenseLimit = monthlyIncome - targetSaving;
    try {
  await widget.db.insert(
    'saving_goal',
    {
      'id': const Uuid().v4(),
      'user_id': widget.userId,
      'monthly_income': monthlyIncome,
      'target_saving': targetSaving,
      'target_expense_limit': expenseLimit,
      'frequency': 1,
      'start_date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      'end_date': null,
      'current_saved': 0,
      'description': description,
      'synced': 0,
    },
  );
} catch (e) {
  print('Error inserting saving goal entry: $e');
}


    setState(() {}); // Refresh expense limit display

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Goal saved successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Planning"),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // Navigate to history page
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Expense limit", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(
              "${expenseLimit.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 16, color: Colors.red),
            ),
            const SizedBox(height: 20),

            // Month selector
            Row(
              children: [
                Expanded(child: Text("Month: $selectedMonth")),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectMonth(context),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Monthly income
            TextField(
              controller: incomeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Monthly Income",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Target saving
            TextField(
              controller: savingController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Target Saving",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Description
            TextField(
              controller: descriptionController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Submit
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitGoal,
                child: const Text("Submit"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
