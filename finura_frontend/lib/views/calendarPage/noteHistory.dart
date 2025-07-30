import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:finura_frontend/services/local_database/local_database_helper.dart';

class NoteHistoryPage extends StatefulWidget {
  @override
  _NoteHistoryPageState createState() => _NoteHistoryPageState();
}

class _NoteHistoryPageState extends State<NoteHistoryPage> {
  List<Map<String, dynamic>> _notes = [];

  // Instance of your DB helper
  final FinuraLocalDbHelper dbHelper = FinuraLocalDbHelper();

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  // Fetch all notes from DB
  Future<void> _loadNotes() async {
    final db = await dbHelper.database;
    final notes = await db.query('note_entry', orderBy: 'updated_at DESC');
    setState(() {
      _notes = notes;
    });
  }

  // Delete a note by ID
  Future<void> _deleteNote(int id) async {
    final db = await dbHelper.database;
    await db.delete('note_entry', where: 'id = ?', whereArgs: [id]);
    _loadNotes(); // Refresh after deletion
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        backgroundColor: const Color.fromARGB(255, 164, 245, 171),
      ),
      body: _notes.isEmpty
          ? Center(child: Text('No notes found'))
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                final note = _notes[index];
                final createdAt = DateFormat.yMMMMd().add_jm().format(DateTime.parse(note['created_at']));
                final updatedAt = DateFormat.yMMMMd().add_jm().format(DateTime.parse(note['updated_at']));

                return Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and delete button row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  note['title'],
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 4),
                                Text("Created: $createdAt", style: TextStyle(color: Colors.grey[600])),
                                Text("Updated: $updatedAt", style: TextStyle(color: Colors.grey[600])),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteNote(note['id']),
                          ),
                        ],
                      ),
                      Divider(thickness: 1),
                      Text(
                        note['content'],
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
