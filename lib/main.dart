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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        title: Text(
          'Seat Finder',
          style: TextStyle(
            color: topTextColor,
          ),
        ),
      ),
      body: Consumer<SearchBarHandler>(
        builder: (context, value, child) {
          log("value from ${value.query}");
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Expanded(child: CustomSearchBar()),
                  ],
                )
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
    Size size = MediaQuery.of(context).size;
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
