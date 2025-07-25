import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final String formattedSelectedDate = DateFormat.yMMMMd().format(
      _selectedDay,
    );
    final String formattedMonth = DateFormat.yMMMM().format(_focusedDay);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 164, 245, 171),
        title: Text('Calendar'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            tooltip: 'History',
            onPressed: () {
              // TODO: Add your history logic here
              print('History icon tapped');
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Top bar with current selected date and current month
              // Top bar with current selected date and current month
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Selected Date - Below current date
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      formattedSelectedDate,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),

                  // Visible Month - Top Right
                  Container(
                    width: double.infinity,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey, width: 1),
                        bottom: BorderSide(color: Colors.grey, width: 1),
                      ),
                    ),
                    child: Text(
                      formattedMonth,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),

              // Calendar
              TableCalendar(
                firstDay: DateTime.utc(2000, 1, 1),
                lastDay: DateTime.utc(2100, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onPageChanged: (focusedDay) {
                  setState(() {
                    _focusedDay = focusedDay;
                  });
                },
                calendarStyle: CalendarStyle(
                  isTodayHighlighted: true,
                  selectedDecoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  defaultDecoration: BoxDecoration(shape: BoxShape.circle),
                  weekendDecoration: BoxDecoration(shape: BoxShape.circle),
                  outsideDecoration: BoxDecoration(shape: BoxShape.circle),
                ),
                headerVisible: false,
                daysOfWeekVisible: true,
                calendarBuilders: CalendarBuilders(
                  outsideBuilder: (context, day, focusedDay) {
                    return Center(child: Text('${day.day}'));
                  },
                ),
              ),

              Divider(thickness: 2, color: Colors.grey, height: 30),

              // Input fields
              SizedBox(height: 10),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _noteController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  hintText: 'Write your note here',
                ),
                maxLines: 3,
              ),

              SizedBox(height: 15),

              // Submit button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: 14,
                    ), // remove horizontal padding
                  ),
                  onPressed: () {
                    String title = _titleController.text.trim();
                    String note = _noteController.text.trim();

                    if (title.isEmpty && note.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please enter a title or note')),
                      );
                      return;
                    }

                    print(
                      'Title: $title\nNote: $note\nDate: $formattedSelectedDate',
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Note saved for $formattedSelectedDate'),
                      ),
                    );

                    _titleController.clear();
                    _noteController.clear();
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
