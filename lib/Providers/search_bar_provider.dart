import 'dart:developer';

import 'package:flutter/widgets.dart';

class SearchBarHandler extends ChangeNotifier {
  String query = '';
  double recurringElementHeight = 0;
  bool enableFind = false;

  Map<int, double> remainder = {};

  set setRecurringElementHeight(double height) {
    recurringElementHeight += height;

    remainder = {
      1: 50,
      2: 50,
      3: 50,
      7: 50,
      4: recurringElementHeight / 2 + 30,
      5: recurringElementHeight / 2 + 30,
      6: recurringElementHeight / 2 + 30,
      0: recurringElementHeight / 2 + 30,
    };
  }

  void setEnableFind(bool enabled) {
    enableFind = enabled;
    notifyListeners();
  }

  void setQuery(
    String text,
    ScrollController scrollController,
  ) {
    query = text;
    if (query != '') {
      double offset = 0;
      log("multiple: ${int.parse(query) ~/ 8}\nremainder: ${remainder[int.parse(query) % 8]!}");
      offset += (int.parse(query) ~/ 8) * recurringElementHeight +
          remainder[int.parse(query) % 8]!;
      log(offset.toString());
      if (scrollController.hasClients) {
        scrollController.animateTo(
            [1, 2, 3, 7].contains(int.parse(query)) ? 0.0 : offset,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut);
      }
    }
    notifyListeners(); // enable this to indicate seat whenever text is changed
  }
}
