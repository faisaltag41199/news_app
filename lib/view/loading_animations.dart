import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late double height;
  late double width;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: height * 0.2),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          color: Colors.white,
          height: height * 0.5,
          width: width * 0.5,
          child: Lottie.asset('assets/lottieJson/newspaperSpinner.json',
              fit: BoxFit.cover),
        ),
      ),
    );
  }
}

class ShimmerEffectNews extends StatefulWidget {
  const ShimmerEffectNews({Key? key}) : super(key: key);

  @override
  State<ShimmerEffectNews> createState() => _ShimmerEffectNewsState();
}

class _ShimmerEffectNewsState extends State<ShimmerEffectNews>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late double height;
  late double width;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.repeat();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: 8),
      height: height,
      width: width,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child: Container(
                height: height * 0.19,
                color: Colors.white,
                child: Lottie.asset('assets/lottieJson/shimmerNewsMain.json',
                    fit: BoxFit.cover,
                    controller: controller, onLoaded: (comp) {
                  controller.forward();
                }),
              ),
            ),
            Expanded(
              child: Container(
                height: height * 0.19,
                color: Colors.white,
                child: Lottie.asset('assets/lottieJson/shimmerNewsMain.json',
                    fit: BoxFit.cover, controller: controller),
              ),
            ),
            Expanded(
              child: Container(
                height: height * 0.19,
                color: Colors.white,
                child: Lottie.asset('assets/lottieJson/shimmerNewsMain.json',
                    fit: BoxFit.cover, controller: controller),
              ),
            ),
            Expanded(
              child: Container(
                height: height * 0.19,
                color: Colors.white,
                child: Lottie.asset('assets/lottieJson/shimmerNewsMain.json',
                    fit: BoxFit.cover, controller: controller),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LottieSearch extends StatefulWidget {
  const LottieSearch({Key? key}) : super(key: key);

  @override
  State<LottieSearch> createState() => _LottieSearchState();
}

class _LottieSearchState extends State<LottieSearch> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Expanded(
        child: Lottie.asset('assets/lottieJson/lottiesearch.json'),
      ),
    );
  }
}
