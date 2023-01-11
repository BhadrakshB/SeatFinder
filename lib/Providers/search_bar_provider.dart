import 'dart:developer';

import 'package:flutter/widgets.dart';

class SearchBarHandler extends ChangeNotifier {
  String query = '';
  int numberofSeats = 72; // Because there are 72 seats in a berth
  double recurringElementHeight = 0;
  bool enableFind = false;

  Map<int, dynamic> residue = {};

  set setRecurringElementHeight(double height) {
    recurringElementHeight = height + 10; // Height of the block in UI

    int constOffset = 30;

    residue = {
      1: constOffset,
      2: constOffset,
      3: constOffset,
      7: constOffset,
      4: recurringElementHeight / 2 + constOffset,
      5: recurringElementHeight / 2 + constOffset,
      6: recurringElementHeight / 2 + constOffset,
      0: recurringElementHeight / 2 + constOffset,
    };
  }

  void setEnableFind(bool enabled) { // Find button greying function
    enableFind = enabled;
    notifyListeners();
  }

  void setQuery( // store the query received
    String text,
    ScrollController scrollController,
  ) {
    query = text;
    if (query != '') {
      double offset = 0;
      double remainder = int.parse(query) % 8; // Tells which seat in 
                                               // the block, aids in 
                                               // scroll offset


      int multiplier = remainder == 0    // Tells which block of row to
          ? (int.parse(query) ~/ 8) - 1  // go to, aids in scroll offset
          : (int.parse(query) ~/ 8);
      
      offset = // scroll offset
          multiplier * recurringElementHeight + residue[int.parse(query) % 8]!;
      if (scrollController.hasClients) {
        scrollController.animateTo(
            [1, 2, 3, 7].contains(int.parse(query)) // condition to check if
                                                    // scroll need for first row
            ? 0.0 : offset,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut);
      }
    }
    notifyListeners(); 
  }
}
