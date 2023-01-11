import 'package:flutter/widgets.dart';

class SearchBarHandler extends ChangeNotifier {
  String query = '';

  void setQuery(String text) {
    query = text;
    notifyListeners();
  }
}
