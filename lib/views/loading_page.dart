import 'package:flutter/material.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.drive_eta,
              color: Theme.of(context).textTheme.bodyText1!.color,
              size: 100,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width*0.3,
                child: LinearProgressIndicator(
              color: Theme.of(context).textTheme.bodyText1!.color,
                  backgroundColor: Colors.transparent,
            ))
          ],
        ),
      ),
    );
  }
}
