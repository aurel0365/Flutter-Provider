import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'global_state_package/lib/global_state.dart';  // Pastikan pathnya benar

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GlobalState>(
      create: (_) => GlobalState(),
      child: MaterialApp(
        title: 'Flutter Demo',
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final globalState = Provider.of<GlobalState>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Flutter Counter App')),
      body: ReorderableListView(
        onReorder: (oldIndex, newIndex) {
          globalState.reorderCounters(oldIndex, newIndex);
        },
        children: globalState.counters
            .asMap()
            .map((index, counterData) {
              return MapEntry(
                index,
                CounterWidget(
                  key: ValueKey(index),
                  label: counterData['label'],
                  color: counterData['color'],
                  counter: counterData['value'],
                  onIncrement: () {
                    globalState.changeCounter(index, counterData['value'] + 1);
                  },
                  onDecrement: () {
                    if (counterData['value'] > 0) {
                      globalState.changeCounter(index, counterData['value'] - 1);
                    }
                  },
                  onLabelChanged: (newLabel) {
                    globalState.changeLabel(index, newLabel);
                  },
                  onColorChanged: (newColor) {
                    globalState.changeColor(index, newColor);
                  },
                  onDelete: () {
                    globalState.removeCounter(index);
                  },
                ),
              );
            })
            .values
            .toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          globalState.addCounter();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class CounterWidget extends StatelessWidget {
  final String label;
  final Color color;
  final int counter;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final ValueChanged<String> onLabelChanged;
  final ValueChanged<Color> onColorChanged;
  final VoidCallback onDelete;

  const CounterWidget({
    Key? key,
    required this.label,
    required this.color,
    required this.counter,
    required this.onIncrement,
    required this.onDecrement,
    required this.onLabelChanged,
    required this.onColorChanged,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      key: key,
      duration: Duration(milliseconds: 300),
      color: color,
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 10),
          Text(
            'Counter Value: $counter',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: onIncrement,
                child: Text('Increment'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: onDecrement,
                child: Text('Decrement'),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.color_lens),
                onPressed: () async {
                  Color? newColor = await _pickColor(context);
                  if (newColor != null) {
                    onColorChanged(newColor);
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () async {
                  String? newLabel = await _editLabel(context);
                  if (newLabel != null) {
                    onLabelChanged(newLabel);
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<Color?> _pickColor(BuildContext context) async {
    Color tempColor = color;
    return await showDialog<Color>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: color,
              onColorChanged: (selectedColor) {
                tempColor = selectedColor;
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, tempColor);
              },
              child: Text('Select'),
            ),
          ],
        );
      },
    );
  }

  Future<String?> _editLabel(BuildContext context) async {
    TextEditingController controller = TextEditingController();
    return await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Label'),
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
