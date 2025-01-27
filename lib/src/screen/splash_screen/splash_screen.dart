import 'dart:async';

import 'package:app_ppmob/app_routes.dart';
import 'package:app_ppmob/src/shared/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  startTime() {
    Timer(const Duration(seconds: 3), () async {
      GoRouter.of(context).pushReplacement(AppRoutes.loginScreen);
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 2.0).animate(_controller);
    _controller.forward();
    startTime();
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            // margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(ImagensAssets.imagemSplash),
            // child: const Text(
            //   'APP MOB',
            //   style: TextStyle(
            //     fontSize: 48,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.white,
            //   ),
            // ),
          ),
        ),
      ),
    );
  }
}
