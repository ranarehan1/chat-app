import 'package:chat_app/screens/authentication/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';
import 'package:page_transition/page_transition.dart';

class GettingStarted extends StatefulWidget {
  const GettingStarted({Key? key}) : super(key: key);

  @override
  State<GettingStarted> createState() => _GettingStartedState();
}

class _GettingStartedState extends State<GettingStarted> {
  bool isFinished = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.13,
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.35,
                child: Image.asset('assets/get_started.png'),),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.09,
            ),
            Stack(
              children: [
                ClipPath(
                  clipper: WaveClipperTwo(
                    flip: true,
                    reverse: true,
                  ),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.43,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.3),
                          Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.5),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.15,
                  right: 0,
                  left: 0,
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.08,
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text(
                          'Experience the world of everyone everywhere.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.2
                        ),
                        child: SwipeableButtonView(

                          buttontextstyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Colors.white,
                          ),
                          buttonColor: Theme.of(context).colorScheme.primary,
                          buttonText: 'Get Started...',
                          buttonWidget:  Container(
                            child: Icon(Icons.arrow_forward_ios_sharp,
                              color: Theme.of(context).colorScheme.secondary,
                            ),),
                          activeColor: Theme.of(context).colorScheme.secondary,
                          isFinished: isFinished,
                          onWaitingProcess: () {
                            Future.delayed(const Duration(seconds: 1), () {
                              setState(() {
                                isFinished = true;
                              });
                            });
                          },
                          onFinish: () async {
                            await Navigator.pushReplacement(context,
                                PageTransition(
                                    type: PageTransitionType.fade,
                                    child: const LoginScreen(),),);
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
