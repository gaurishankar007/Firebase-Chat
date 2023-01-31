import 'package:firebase_chat/src/core/constant.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    Color primaryContainer = Theme.of(context).colorScheme.primaryContainer;
    Color surface = Theme.of(context).colorScheme.surface;

    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView(
            scrollDirection: Axis.horizontal,
            physics: ClampingScrollPhysics(),
            controller: PageController(
              initialPage: 0,
              keepPage: false,
              viewportFraction: 1,
            ),
            onPageChanged: (index) {
              setState(() {
                pageIndex = index;
              });
            },
            children: [
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: sWidth(context) * .04),
                width: double.maxFinite,
                height: double.maxFinite,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: const [
                      Color(0xFF3287fb),
                      Color(0xFF5DA1FF),
                      Color(0xFF3287fb),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: sHeight(context) * .05,
                    ),
                    Image(
                      width: sWidth(context) * .75,
                      fit: BoxFit.fitWidth,
                      image: AssetImage("assets/images/bannerImage.png"),
                    ),
                    SizedBox(
                      height: sHeight(context) * .15,
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: surface,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Text(
                        "Get Started",
                        style: TextStyle(
                          color: primaryContainer,
                          fontSize: 54,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.maxFinite,
                height: double.maxFinite,
                padding:
                    EdgeInsets.symmetric(horizontal: sWidth(context) * .04),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: const [
                      Color(0xFF3287fb),
                      Color(0xFF5DA1FF),
                      Color(0xFF3287fb),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: sHeight(context) * .05,
                    ),
                    Image(
                      width: sWidth(context) * .75,
                      fit: BoxFit.fitWidth,
                      image: AssetImage("assets/images/bannerImage.png"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "A new way to stay connected with us",
                      style: TextStyle(
                        color: surface,
                        fontSize: 54,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Let's talk about stuff with the people you are closest to.",
                      style: veryLargeText.copyWith(
                        color: surface.withOpacity(.8),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.maxFinite,
                height: double.maxFinite,
                padding:
                    EdgeInsets.symmetric(horizontal: sWidth(context) * .04),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: const [
                      Color(0xFF3287fb),
                      Color(0xFF5DA1FF),
                      Color(0xFF3287fb),
                    ],
                  ),
                ),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: sHeight(context) * .05,
                        ),
                        Image(
                          width: sWidth(context) * .75,
                          fit: BoxFit.fitWidth,
                          image: AssetImage("assets/images/bannerImage.png"),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "A new way to stay connected with us",
                          style: TextStyle(
                            color: surface,
                            fontSize: 54,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Let's talk about stuff with the people you are closest to.",
                          style: veryLargeText.copyWith(
                            color: surface.withOpacity(.8),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/signIn");
                        },
                        child: Text("Sign In"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            child: AnimatedSmoothIndicator(
              activeIndex: pageIndex,
              count: 3,
              effect: ExpandingDotsEffect(
                dotColor: Colors.white.withOpacity(.7),
                activeDotColor: primaryContainer,
                dotHeight: 8,
                dotWidth: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
