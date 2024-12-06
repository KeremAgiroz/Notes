import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart'; // Tarih formatlama için

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> notes = []; // Notları liste şeklinde sakla

  @override
  Widget build(BuildContext context) {
    // Notları tarih sırasına göre (en yeni en üstte) sıralama
    notes.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.add),
            onPressed: () async {
              final newNote = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteScreen(
                    initialText: '',
                    initialTextColor: Colors.black,
                    initialBackgroundColor: Colors.white,
                  ),
                ),
              );
              if (newNote != null) {
                setState(() {
                  notes.add(newNote);
                });
              }
            },
          ),
        ],
      ),
      body: notes.isEmpty
          ? const Center(
              child: Text(
                'Henüz bir not yok!',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return Card(
                  color: notes[index]['backgroundColor'],
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        notes[index]['text'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: notes[index]['textColor'],
                        ),
                      ),
                    ),
                    subtitle: Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        notes[index]['timestamp'] != null
                            ? DateFormat('yyyy-MM-dd HH:mm:ss')
                                .format(notes[index]['timestamp'])
                            : 'Tarih bulunamadı',
                        style: TextStyle(
                          fontSize: 12,
                          color: notes[index]['textColor'], // Tarih rengi
                        ),
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        CupertinoIcons.delete,
                        color: notes[index]['textColor'], // Çöp kutusu rengi
                      ),
                      onPressed: () {
                        _showDeleteConfirmation(context, index);
                      },
                    ),
                    onTap: () async {
                      final updatedNote = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NoteScreen(
                            initialText: notes[index]['text'],
                            initialTextColor: notes[index]['textColor'],
                            initialBackgroundColor: notes[index]
                                ['backgroundColor'],
                          ),
                        ),
                      );
                      if (updatedNote != null) {
                        setState(() {
                          notes[index] = updatedNote;
                        });
                      }
                    },
                  ),
                );
              },
            ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Notu Sil'),
          content: const Text('Bu notu silmek istediğinizden emin misiniz?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Hayır'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  notes.removeAt(index);
                });
                Navigator.pop(context);
              },
              child: const Text(
                'Evet',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Not ekranı
class NoteScreen extends StatefulWidget {
  final String initialText;
  final Color initialTextColor;
  final Color initialBackgroundColor;

  const NoteScreen({
    super.key,
    required this.initialText,
    required this.initialTextColor,
    required this.initialBackgroundColor,
  });

  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  late TextEditingController _controller;
  late Color _textColor;
  late Color _backgroundColor;

  final List<Color> colors = [
    Colors.purple,
    Colors.red,
    Colors.brown,
    Colors.white,
    Colors.blue.shade900,
    Colors.green,
    Colors.yellow,
    Colors.grey,
    Colors.black,
    Colors.pink,
    Colors.orange,
    Colors.blue,
    Colors.teal,
  ];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
    _textColor = widget.initialTextColor;
    _backgroundColor = widget.initialBackgroundColor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.check_mark),
            onPressed: () {
              Navigator.pop(context, {
                'text': _controller.text,
                'textColor': _textColor,
                'backgroundColor': _backgroundColor,
                'timestamp': DateTime.now(),
              });
            },
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.clear),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'text') {
                _pickColor(context, true);
              } else if (value == 'background') {
                _pickColor(context, false);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'text',
                child: Text('Yazı Rengini Seç'),
              ),
              const PopupMenuItem(
                value: 'background',
                child: Text('Arka Plan Rengini Seç'),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: _backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              maxLines: null,
              style: TextStyle(color: _textColor),
              decoration: const InputDecoration(
                hintText: 'Notunuzu buraya yazın...',
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickColor(BuildContext context, bool isTextColor) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:
              Text(isTextColor ? 'Yazı Rengini Seç' : 'Arka Plan Rengini Seç'),
          content: SizedBox(
            width: double.maxFinite,
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: colors.map((color) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isTextColor) {
                        _textColor = color;
                      } else {
                        _backgroundColor = color;
                      }
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
