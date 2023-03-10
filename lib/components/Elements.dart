import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../Providers/search_bar_provider.dart';
import '../constants.dart';

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

  get backgroundColor => null;

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
                            child: Consumer<SearchBarHandler>(
                              builder: ((context, value, child) {
                                bool selected =
                                    (index + i).toString() == value.query;

                                Text textWidget = const Text("");
                                // Text to denote berth levels
                                TextStyle textStyle = TextStyle(
                                  fontFamily: 'PublicaPlay',
                                  // This textstyle is for berth levels..LOWER,
                                  // MIDDLE, UPPER etc.
                                  fontSize: 7,
                                  fontWeight: FontWeight.bold,
                                  color: selected
                                      ? backgroundColor
                                      : berthTextColor,
                                );
                                switch (i) {
                                  case 0:
                                    textWidget = Text(
                                        isBig ? "LOWER" : "SIDE LOWER",
                                        style: textStyle);
                                    break;
                                  case 1:
                                    textWidget =
                                        Text("MIDDLE", style: textStyle);
                                    break;
                                  case 2:
                                    textWidget =
                                        Text("UPPER", style: textStyle);
                                    break;
                                  default:
                                }

                                return Stack(
                                  alignment: const Alignment(0, 0.9),
                                  children: [
                                    Container(
                                      height: side,
                                      width: side,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: !selected
                                            ? berthColor
                                            : berthTextColor,
                                      ),
                                      child: Center(
                                        child: Text(
                                          "${index + i}",
                                          style: TextStyle(
                                            fontFamily: 'PublicaPlay',
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: selected
                                                ? backgroundColor
                                                : berthTextColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    textWidget,
                                  ],
                                );
                              }),
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
                            child: Consumer<SearchBarHandler>(
                              builder: ((context, value, child) {
                                bool selected =
                                    (index + (isBig ? 3 : 1) + i).toString() ==
                                        value.query;

                                Text textWidget = const Text(
                                    ""); // Text Widget for denoting berth levels
                                TextStyle textStyle = TextStyle(
                                  fontFamily: 'PublicaPlay',
                                  // This textstyle is for berth levels..LOWER, MIDDLE, UPPER etc.
                                  fontSize: 7,
                                  fontWeight: FontWeight.bold,
                                  color: selected
                                      ? backgroundColor
                                      : berthTextColor,
                                );
                                switch (i) {
                                  case 0:
                                    textWidget = Text(
                                        isBig ? "LOWER" : "SIDE UPPER",
                                        style: textStyle);
                                    break;
                                  case 1:
                                    textWidget =
                                        Text("MIDDLE", style: textStyle);
                                    break;
                                  case 2:
                                    textWidget =
                                        Text("UPPER", style: textStyle);
                                    break;
                                  default:
                                }

                                return Stack(
                                  alignment: const Alignment(0, -0.9),
                                  children: [
                                    Container(
                                      height: side,
                                      width: side,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: !selected
                                            ? berthColor
                                            : berthTextColor,
                                      ),
                                      child: Center(
                                        child: Text(
                                          "${index + (isBig ? 3 : 1) + i}",
                                          style: TextStyle(
                                            fontFamily: 'PublicaPlay',
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: selected
                                                ? backgroundColor
                                                : berthTextColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    textWidget,
                                  ],
                                );
                              }),
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

class CustomSearchBar extends StatefulWidget {
  final ScrollController scrollController;

  const CustomSearchBar({Key? key, required this.scrollController})
      : super(key: key);

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  double height = 50;

  TextEditingController textFormFieldController = TextEditingController();

  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: height,
          child: TextField(
            focusNode: focusNode,
            controller: textFormFieldController,
            textAlignVertical: TextAlignVertical.center,
            keyboardType: TextInputType.phone,
            onChanged: (value) {
              // Enable this setQuery function inside onChanged, ONLY
              // if you want to show berth as the input changes

//              context
//                  .read<SearchBarHandler>()
//                  .setQuery(value, scrollController);

              ScaffoldMessenger.of(context).clearSnackBars();
              if (value != '') {
                if (int.parse(value) > 72) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('There are only 72 seats per berth'),
                    ),
                  );
                } else if (int.parse(value) == 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Seat Number cannot be 0'),
                    ),
                  );
                }
                context.read<SearchBarHandler>().setEnableFind(
                    int.parse(value) > 72 || int.parse(value) == 0
                        ? false
                        : true);
              } else {
                context.read<SearchBarHandler>().setEnableFind(false);
              }
            },
            onSubmitted: (value) {
              // Enable onSubmitted, if you want to show berth ONLY
              // when the user completes the query
              context
                  .read<SearchBarHandler>()
                  .setQuery(value, widget.scrollController);
            },
            maxLines: null,
            minLines: null,
            expands: true,
            style: TextStyle(
              fontFamily: 'PublicaPlay',
              letterSpacing: 2,
              color: topTextColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.only(left: 10),
              hintText: "Enter Seat Number...",
              hintStyle: TextStyle(
                letterSpacing: 2,
                fontFamily: 'PublicaPlay',
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
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Consumer<SearchBarHandler>(
            builder: (context, value, child) {
              bool enabled = value.enableFind;
              return TextButton(
                onPressed: enabled
                    ? () => context.read<SearchBarHandler>().setQuery(
                        textFormFieldController.value.text,
                        widget.scrollController)
                    : () {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text("Please enter your query first")));
                      },
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
                    fontFamily: 'PublicaPlay',
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
