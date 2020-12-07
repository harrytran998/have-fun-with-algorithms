import 'package:flutter/material.dart';


// The App will start as a stateful widget
class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

          Text(
            'alg.io',
            style: Theme.of(context).textTheme.headline1,
          ),

          // A button which will progress the app when pressed
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FlatButton(
              color: Colors.white24,
              onPressed: () => Navigator.of(context).pushNamed('/home'),
              child: Container(
                child: Text(
                  'Continue to App',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

}