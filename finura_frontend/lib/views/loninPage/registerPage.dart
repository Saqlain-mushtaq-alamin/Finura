import 'package:finura_frontend/services/local_database/local_database_helper.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'dart:io';

// Dummy function to simulate storing user data in a database
Future<void> storeUserData({
  required String firstName,
  required String lastName,
  required String email,
  required String occupation,
  required String sex,
  required String pin, // Already hashed
  String? photoPath,
}) async {
  final db = await FinuraLocalDbHelper.instance.database;

  String? savedImagePath;

  // ...existing code...
  if (photoPath != null) {
    // Use your desired assets path
    final customDir = Directory(
      'D:/canvas/Finura/finura_frontend/assets/user_photo',
    );
    if (!await customDir.exists()) {
      await customDir.create(recursive: true);
    }
    final fileName = basename(photoPath);
    final newImagePath = '${customDir.path}/$fileName';

    // Copy the image to the assets directory
    await File(photoPath).copy(newImagePath);
    savedImagePath = newImagePath;
  }
  // ...existing code...

  await db.insert('user', {
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
    'occupation': occupation,
    'sex': sex,
    'pin_hash': pin,
    'created_at': DateTime.now().toIso8601String(),
    'usger_photo': savedImagePath, // ✅ saved file path
    'data_status': null,
  });

  print('User stored successfully.');
}

// Function to hash the pin using SHA256
String hashPin(String pin) {
  final bytes = utf8.encode(pin);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();

  String? _selectedSex;
  File? _photo;

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _photo = File(pickedFile.path);
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Handle registration logic here
      ScaffoldMessenger.of(
        context as BuildContext,
      ).showSnackBar(const SnackBar(content: Text('Registration submitted!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.green[700],
        // Fixed invalid shade
      ),
      body: Container(
        width: double.infinity,
        color: Colors.green[100], // Fixed invalid shade
        alignment: Alignment.center,

        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickPhoto,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: _photo != null ? FileImage(_photo!) : null,
                    child: _photo == null
                        ? const Icon(Icons.camera_alt, size: 40)
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(labelText: 'First Name'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Enter first name'
                      : null,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(labelText: 'Last Name'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter last name' : null,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter email' : null,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _occupationController,
                  decoration: const InputDecoration(labelText: 'Occupation'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Enter occupation'
                      : null,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedSex,
                  decoration: const InputDecoration(labelText: 'Sex'),
                  items: const [
                    DropdownMenuItem(value: 'Male', child: Text('Male')),
                    DropdownMenuItem(value: 'Female', child: Text('Female')),
                    DropdownMenuItem(value: 'Other', child: Text('Other')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedSex = value;
                    });
                  },
                  validator: (value) => value == null ? 'Select sex' : null,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _pinController,
                  decoration: const InputDecoration(labelText: 'PIN'),
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter PIN' : null,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _confirmPinController,
                  decoration: const InputDecoration(labelText: 'Confirm PIN'),
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirm your PIN';
                    }
                    if (value != _pinController.text) {
                      return 'PINs do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 50),
                ElevatedButton(onPressed: _submit, child: const Text('Submit')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
