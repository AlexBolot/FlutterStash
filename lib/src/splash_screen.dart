/*..............................................................................
 . Copyright (c)
 .
 . The splash_screen.dart class was created by : Alexandre Bolot
 .
 . As part of the FlutterStash project
 .
 . Last modified : 13/02/2021
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'package:flutter/material.dart';
import 'package:flutter_stash/flutter_stash.dart';

class SplashScreen extends StatefulWidget {
  /// Use this for easier access from Named-Routes navigation
  static const String routeName = "/SplashScreen";

  /// Text displayed as title of this view (in the appbar)
  ///
  /// Defaults to an empty string
  final String title;

  /// The name of the route to Navigate towards when everything is loaded
  ///
  /// If null, the field [nextRoute] will be used instead
  final String? nextRouteName;

  /// The MaterialPageRoute used to Navigate when everything is loaded
  ///
  /// Only used if the field [nextRouteName] is null
  final MaterialPageRoute? nextRoute;

  /// List of sync or async functions that will be awaited on
  final List<Function> waitFor;

  /// List of sync or async functions that will NOT be awaited on
  final List<Function> noWaitFor;

  const SplashScreen({
    this.title = '',
    this.nextRouteName,
    this.nextRoute,
    this.waitFor = const [],
    this.noWaitFor = const [],
  }) : assert(nextRouteName != null || nextRoute != null);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  /// Animated [BubbleLoader] used for user feedback
  /// during the duration of the actual data loading
  BubbleLoader loader = BubbleLoader();

  @override
  void initState() {
    super.initState();

    // Trigger async tasks in this method
    applicationLoading();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Stack(
          alignment: Alignment(0, -1),
          children: <Widget>[
            Container(
              width: double.infinity,
              height: screenHeight * 2 / 5,
              child: Container(
                margin: EdgeInsets.all(0),
                color: Theme.of(context).primaryColor,
                child: Center(
                  child: Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      color: contrastOf(Theme.of(context).primaryColor),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: screenHeight * 2 / 5),
              width: double.infinity,
              height: screenHeight * 3 / 5,
              child: Center(
                child: Container(
                  child: loader,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  applicationLoading() async {
    //Perform all tasks (usually async) here
    for (Function function in widget.waitFor) {
      await function();
    }

    for (Function function in widget.noWaitFor) {
      function();
    }

    // Stop the loader animation
    loader.dispose();

    // Navigate to the next page here
    if (widget.nextRouteName != null)
      Navigator.of(context).pushReplacementNamed(widget.nextRouteName!);
    else if (widget.nextRoute != null)
      Navigator.of(context).push(widget.nextRoute!);
    else
      throw 'Both [nextRouteName] and [nextRoute] are null !\n'
          'Unable to navigate out of ${this.runtimeType}';
  }
}
