import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GlobalState extends ChangeNotifier {
  // List untuk menyimpan data counter dengan label, nilai, dan warna
  List<Map<String, dynamic>> _counters = [];

  // Getter untuk mendapatkan daftar counters
  List<Map<String, dynamic>> get counters => _counters;

  // Method untuk menambah counter baru
  void addCounter() {
    _counters.add({
      'label': 'Counter ${_counters.length + 1}', // Label default
      'value': 0, // Nilai awal counter
      'color': Colors.blue, // Warna default counter
    });
    notifyListeners(); // Memberi tahu listener bahwa ada perubahan
  }

  // Method untuk menghapus counter
  void removeCounter(int index) {
    _counters.removeAt(index);
    notifyListeners();
  }

  // Method untuk mengubah nilai counter
  void changeCounter(int index, int value) {
    _counters[index]['value'] = value;
    notifyListeners();
  }

  // Method untuk mengubah label counter
  void changeLabel(int index, String newLabel) {
    _counters[index]['label'] = newLabel;
    notifyListeners();
  }

  // Method untuk mengubah warna counter
  void changeColor(int index, Color newColor) {
    _counters[index]['color'] = newColor;
    notifyListeners();
  }
}
