import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() => runApp(MyEphemeralApp());

class MyEphemeralApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Advanced UI and Interactivity')),
        body: CounterListWidget(),
      ),
    );
  }
}

class CounterListWidget extends StatefulWidget {
  @override
  _CounterListWidgetState createState() => _CounterListWidgetState();
}

class _CounterListWidgetState extends State<CounterListWidget> {
  List<CounterItem> counters = [
    CounterItem(label: 'Box 1', color: Colors.blue),
    CounterItem(label: 'Box 2', color: Colors.green),
    CounterItem(label: 'Box 3', color: Colors.red),
    CounterItem(label: 'Box 4', color: const Color.fromARGB(255, 102, 23, 249)),

  ];

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      onReorder: _onReorder,
      children: counters
          .map((counter) => ListTile(
                key: ValueKey(counter),
                title: CounterWidget(
                  label: counter.label,
                  color: counter.color,
                  onColorChanged: (color) {
                    setState(() {
                      counter.color = color;
                    });
                  },
                  onLabelChanged: (label) {
                    setState(() {
                      counter.label = label;
                    });
                  },
                ),
              ))
          .toList(),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final CounterItem item = counters.removeAt(oldIndex);
      counters.insert(newIndex, item);
    });
  }
}

class CounterItem {
  String label;
  Color color;
  CounterItem({required this.label, required this.color});
}

class CounterWidget extends StatefulWidget {
  final String label;
  final Color color;
  final ValueChanged<Color> onColorChanged;
  final ValueChanged<String> onLabelChanged;

  const CounterWidget({
    Key? key,
    required this.label,
    required this.color,
    required this.onColorChanged,
    required this.onLabelChanged,
  }) : super(key: key);

  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _counter = 0;
  late Color _color;

  @override
  void initState() {
    super.initState();
    _color = widget.color;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      color: _color,
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: <Widget>[
          Text(
            widget.label,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 10),
          Text(
            'Counter Value: $_counter',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _counter++;
                  });
                },
                child: Text('Increment'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (_counter > 0) {
                      _counter--;
                    }
                  });
                },
                child: Text('Decrement'),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.color_lens),
                onPressed: () async {
                  Color? selectedColor = await _showColorPicker(context);
                  if (selectedColor != null) {
                    widget.onColorChanged(selectedColor);
                    setState(() {
                      _color = selectedColor;
                    });
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () async {
                  String? newLabel = await _showLabelDialog(context);
                  if (newLabel != null && newLabel.isNotEmpty) {
                    widget.onLabelChanged(newLabel);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<Color?> _showColorPicker(BuildContext context) async {
    return await showDialog<Color>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _color,
              onColorChanged: (color) {
                setState(() {
                  _color = color;
                });
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, _color);
              },
              child: Text('Select'),
            ),
          ],
        );
      },
    );
  }

  Future<String?> _showLabelDialog(BuildContext context) async {
    TextEditingController controller = TextEditingController();
    return await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Change Label'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Enter new label'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, controller.text);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
