// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:developer';

import 'main.dart';

class LottieSplashScreen extends StatefulWidget {
  const LottieSplashScreen({Key? key}) : super(key: key);

  @override
  _LottieSplashScreenState createState() => _LottieSplashScreenState();
}

class _LottieSplashScreenState extends State<LottieSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          'Assets/Seat Finder splash animation.json',
          animate: true,
          controller: _controller,
          width: 300,
          height: 300,
          onLoaded: (p0) {
            log("${p0.duration.inSeconds}");
            _controller
              ..duration = p0.duration
              ..forward();
            Future.delayed(
              p0.duration,
              () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const MyHomePage()),
            ),
            );
          },
        ),
      ),
    );
  }
}
