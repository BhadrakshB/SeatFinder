import 'dart:developer';

import 'package:flutter/widgets.dart';

class SearchBarHandler extends ChangeNotifier {
  String query = '';
  double recurringElementHeight = 20;

  Map<int, double> remainder = {
    1: 0,
    2: 0,
    3: 0,
    7: 0,
    4: 40,
    5: 40,
    6: 40,
    8: 40,
  };

  set setRecurringElementHeight(double height) {
    remainder = {
      1: 0,
      2: 0,
      3: 0,
      7: 0,
      4: height / 2,
      5: height / 2,
      6: height / 2,
      0: height / 2,
    };
    recurringElementHeight += height;
  }

  void setQuery(
    String text,
    // BuildContext context,
    ScrollController scrollController,
  ) {
    query = text;
    if (query != '') {
      double offset = 0;
      log("multiple: ${int.parse(query) ~/ 8}\nremainder: ${remainder[int.parse(query) % 8]!}");
      offset += int.parse(query) ~/ 8 + remainder[int.parse(query) % 8]!;
      log(offset.toString());
      if (scrollController.hasClients) {
        scrollController.animateTo(offset,
            duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      }
    }
    notifyListeners();
  }
}
