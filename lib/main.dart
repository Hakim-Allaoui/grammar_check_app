import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:grammar_check_app/constants.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart'; // Import for clipboard functionality

// Entry point of the application
void main() {
  runApp(MyApp());
}

// Main application widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grammar & Writing Assistant',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Helvetica',
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ApiService {
  String _selectedTask = 'Check Grammar';

  String get selectedTask => _selectedTask;

  void setSelectedTask(String task) {
    _selectedTask = task;
  }

  static const String _apiKey = API_KEY;
  static const String _apiUrl = 'https://api.openai.com/v1/chat/completions';

  Future<String> performTask(String userInput) async {
    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages': [
          {
            'role': 'system',
            'content':
                'You are a quote generator that generates unique quotes every time an API request is made. Generate quotes of type $_selectedTask'
          },
          {'role': 'user', 'content': '$userInput'},
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'].trim();
    } else {
      throw Exception('Failed to communicate with the API: ${response.body}');
    }
  }
}

// Home screen widget
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

// State class for HomeScreen
class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  final ApiService _apiService = ApiService();
  String _result = '';
  bool _isLoading = false;

  // List of available tasks
  final List<String> _tasks = [
    'Check Grammar',
    'Write Article',
    'Write Essay',
    'Summarize Text',
    'Translate Text',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Grammar & Writing Assistant',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: GestureDetector(
        // Dismiss keyboard when tapping outside
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Task Selector Dropdown
              Text(
                'Select Task',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.green[700],
                ),
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _apiService.selectedTask,
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down, color: Colors.green[700]),
                    dropdownColor: Colors.green[50],
                    items: _tasks.map((String task) {
                      return DropdownMenuItem<String>(
                        value: task,
                        child: Text(
                          task,
                          style: TextStyle(
                            color: Colors.green[800],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _apiService.setSelectedTask(newValue);
                        });
                      }
                    },
                  ),
                ),
              ),
              SizedBox(height: 24),

              // Text Input Field
              Text(
                'Your Text',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.green[700],
                ),
              ),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _controller,
                  maxLines: 10,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    border: InputBorder.none,
                    hintText: 'Enter your text here...',
                    hintStyle: TextStyle(color: Colors.green[300]),
                  ),
                  style: TextStyle(color: Colors.green[900], fontSize: 16),
                ),
              ),
              SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors
                        .green[700], // Use backgroundColor instead of primary
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: 30.0,
                          width: 30.0,
                          child: const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : /* Text(
                          'Submit',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ) */
                      Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                ),
              ),
              SizedBox(height: 24),

              // Result Section
              if (_result.isNotEmpty) ...[
                Text(
                  'Result:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.green[700],
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    _result,
                    style: TextStyle(
                      color: Colors.green[800],
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: _result));
                    _showSnackBar('Copied to clipboard!');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Copy'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // Handle Submit Button Press
  Future<void> _handleSubmit() async {
    final userInput = _controller.text.trim();
    if (userInput.isEmpty) {
      _showSnackBar('Please enter some text.');
      return;
    }

    setState(() {
      _isLoading = true;
      _result = '';
    });

    try {
      final taskPrompt = '${_apiService.selectedTask}: $userInput';
      final result = await _apiService.performTask(taskPrompt);
      setState(() {
        _result = result;
      });
    } catch (e) {
      _showSnackBar('Error: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Display a snackbar with a message
  void _showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.green[300],
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
