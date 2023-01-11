import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seat_finder/Providers/search_bar_provider.dart';
import 'package:seat_finder/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SearchBarHandler()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Seat Finder',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScrollController scrollController = ScrollController(
    keepScrollOffset: true,
  );

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width - 225;
    double sideLength = (width - 12) / 3;

    double height = sideLength * 2 + 30;

    return Scaffold(
      body: Consumer<SearchBarHandler>(
        builder: (context, value, child) {
          log("value from ${value.query}");
          return Padding(
            padding: EdgeInsets.only(
              left: 15,
              right: 15,
              top: MediaQuery.of(context).viewPadding.top + 30,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Seat Finder',
                  style: TextStyle(
                    color: topTextColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Row(
                    children: [
                      Expanded(child: CustomSearchBar()),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: 5,
                      controller: scrollController,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        log("currentIndex: ${index * 8 + 1}");
                        return RecurringElement(
                          height: height,
                          width: width,
                          side: sideLength,
                          index: index * 8 + 1,
                        );
                      }),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CustomSearchBar extends StatelessWidget {
  CustomSearchBar({Key? key}) : super(key: key);
  double height = 50;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: height,
          child: TextFormField(
            textAlignVertical: TextAlignVertical.center,

            keyboardType: TextInputType.phone,
            onChanged: (value) {
              log("new value: $value");
              context.read<SearchBarHandler>().setQuery(value);
            },
            maxLines: null,
            minLines: null,

            expands: true,
            style: TextStyle(
              color: topTextColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.only(left: 10),
              hintText: "Enter Seat Number...",
              hintStyle: TextStyle(
                color: topTextColor,
                fontWeight: FontWeight.bold,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: topTextColor,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: topTextColor,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              fillColor: backgroundColor,
              filled: true,
            ),
            // enabled: editable,
            // readOnly: !editable,
            // initialValue: latestClipboardValue,
            // !editable ? latestClipboardValue : "",
            // !editable
            //     ? latestClipboardValue == "" ? "Nothing in clipboard. Copy data to proceed"
            //     : latestClipboardValue : "",
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Consumer<SearchBarHandler>(
            builder: (context, value, child) {
              bool enabled = value.query != '';
              log("$enabled");
              return TextButton(
                onPressed: enabled ? () {} : () {},
                style: TextButton.styleFrom(
                  backgroundColor: enabled ? topTextColor : Colors.grey,
                  minimumSize: Size(100, height),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Find",
                  style: TextStyle(
                    color: backgroundColor,
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}

class HalfBorderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height * (25 / 100));
    path.lineTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * (25 / 100));

    path.moveTo(size.width, size.height * (75 / 100));
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, size.height * (75 / 100));
    // path.lineTo(size.width, size.height / 2);
    // path.lineTo(0, size.height / 2);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class Berth extends StatelessWidget {
  final double height;
  final double width;
  final double side;
  final bool isBig;
  final int index;
  const Berth(
      {super.key,
      required this.height,
      required this.width,
      required this.side,
      required this.index,
      required this.isBig});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          height: height + 10,
          width: width + 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      isBig ? 3 : 1,
                      (i) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 2,
                              vertical: 2,
                            ),
                            child: Container(
                              key: Key("${index + i}"),
                              height: side,
                              width: side,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: berthColor,
                              ),
                              child: Center(child: Text("${index + i}")),
                            ),
                          ),
                        );
                      },
                    )),
              ),
              Expanded(
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(
                      isBig ? 3 : 1,
                      (i) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 2,
                              vertical: 2,
                            ),
                            child: Container(
                              key: Key("${index + (isBig ? 3 : 1 )+ i}"),
                              height: side,
                              width: side,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: berthColor,
                              ),
                              child: Center(child: Text("${index +(isBig ? 3 : 1 )+ i}")),
                            ),
                          ),
                        );
                      },
                    )),
              ),
            ],
          ),
        ),
        ClipPath(
          clipper: HalfBorderClipper(),
          child: Container(
            height: height + 8,
            width: width,
            decoration: BoxDecoration(
              border: Border.all(
                color: topTextColor,
                width: 6,
                style: BorderStyle.solid,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// class SmallBerth extends StatelessWidget {
//   final double height;
//   final double width;
//   final double side;
//   const SmallBerth(
//       {super.key,
//       required this.height,
//       required this.width,
//       required this.side});

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         Container(
//           padding: const EdgeInsets.all(2),
//           height: height + 10,
//           width: width + 5,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Expanded(
//                 child: Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: List.generate(
//                       1,
//                       (index) {
//                         return Expanded(
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 2,
//                               vertical: 2,
//                             ),
//                             child: Container(
//                               height: side,
//                               width: side,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(8),
//                                 color: berthColor,
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     )),
//               ),
//               Expanded(
//                 child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: List.generate(
//                       1,
//                       (index) {
//                         return Expanded(
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 2,
//                               vertical: 2,
//                             ),
//                             child: Container(
//                               height: side,
//                               width: side,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(8),
//                                 color: berthColor,
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     )),
//               ),
//             ],
//           ),
//         ),
//         ClipPath(
//           clipper: HalfBorderClipper(),
//           child: Container(
//             height: height + 8,
//             width: width,
//             decoration: BoxDecoration(
//               border: Border.all(
//                 color: topTextColor,
//                 width: 6,
//                 style: BorderStyle.solid,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

class RecurringElement extends StatelessWidget {
  // Big Berth + Small Berth element that is repeating inside the listview
  final double height;
  final double width;
  final double side;
  final int index;
  const RecurringElement({
    super.key,
    required this.height,
    required this.width,
    required this.side,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Berth(
          height: height,
          width: width,
          side: side,
          index: index,
          isBig: true,
        ),
        Berth(
          height: height,
          width: side + 10,
          side: side,
          index: index + 6,
          isBig: false,
        )
      ],
    );
  }
}
