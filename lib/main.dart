import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seat_finder/Providers/search_bar_provider.dart';
import 'package:seat_finder/constants.dart';

import 'components/Elements.dart';
import 'splash_screen_lottie.dart';

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
        home: const LottieSplashScreen(),
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

    context.read<SearchBarHandler>().setRecurringElementHeight = height;

    return Scaffold(
      body: Padding(
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
                fontFamily: 'PublicaPlay',
                color: topTextColor,
                fontSize: 20,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: CustomSearchBar(scrollController: scrollController),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: context.read<SearchBarHandler>().numberofSeats ~/
                      8, // Because there are 72 berth per berth
                  controller: scrollController,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
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
      ),
    );
  }
}
