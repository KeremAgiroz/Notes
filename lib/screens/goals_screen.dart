import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Shared Preferences importu

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  _GoalsScreenState createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  List<Map<String, dynamic>> _goals = [];

  @override
  void initState() {
    super.initState();
    _loadGoals(); // Uygulama başladığında hedefleri yükle
  }

  // SharedPreferences'tan hedefleri yükleme
  Future<void> _loadGoals() async {
    final prefs = await SharedPreferences.getInstance();
    final goalsList =
        prefs.getStringList('goals') ?? []; // 'goals' key'inden veriyi al

    setState(() {
      _goals = goalsList.map((goal) {
        final parts = goal.split('|'); // Hedef ve tarih arasını ayır
        return {
          'goal': parts[0],
          'dateTime': DateTime.parse(parts[1]),
        };
      }).toList();
    });
  }

  // Yeni hedef kaydetme
  Future<void> _saveGoal(Map<String, dynamic> goal) async {
    final prefs = await SharedPreferences.getInstance();
    final goalsList = prefs.getStringList('goals') ?? [];

    goalsList.add(
        '${goal['goal']}|${goal['dateTime']}'); // Hedef ve tarihi birleştir

    await prefs.setStringList(
        'goals', goalsList); // Güncellenmiş listeyi kaydet

    setState(() {
      _goals.add(goal); // Listeyi ekrana yansıt
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hedeflerim'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final newGoal = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NewGoalScreen(),
                ),
              );

              if (newGoal != null) {
                _saveGoal(
                    newGoal); // Hedef kaydedildiğinde veriyi SharedPreferences'a kaydet
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _goals.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: ListTile(
              title: Text(_goals[index]['goal']),
              subtitle: Text(
                'Tarih: ${DateFormat('yyyy-MM-dd').format(_goals[index]['dateTime'])}',
              ),
            ),
          );
        },
      ),
    );
  }
}

class NewGoalScreen extends StatefulWidget {
  const NewGoalScreen({super.key});

  @override
  _NewGoalScreenState createState() => _NewGoalScreenState();
}

class _NewGoalScreenState extends State<NewGoalScreen> {
  final TextEditingController _goalController = TextEditingController();
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Hedef Ekle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _goalController,
              decoration: const InputDecoration(
                labelText: 'Hedefinizi Yazın',
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(_selectedDate == null
                    ? 'Tarih Seçin'
                    : 'Seçilen Tarih: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}'),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: _selectDate,
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _saveGoal,
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selected != null && selected != _selectedDate) {
      setState(() {
        _selectedDate = selected;
      });
    }
  }

  void _saveGoal() {
    if (_goalController.text.isEmpty || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen hedef ve tarih girin')),
      );
      return;
    }

    Navigator.pop(context, {
      'goal': _goalController.text,
      'dateTime': _selectedDate,
    });
  }
}
