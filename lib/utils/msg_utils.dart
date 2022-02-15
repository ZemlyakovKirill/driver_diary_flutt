import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

errorSnack(BuildContext context, String message) {
  showTopSnackBar(
    context,
    CustomSnackBar.error(
      message: message,
    ),
    displayDuration: Duration(seconds: 2),
  );
}

successSnack(BuildContext context, String message) {
  showTopSnackBar(
    context,
    CustomSnackBar.success(
      message: message,
    ),
    displayDuration: Duration(seconds: 2),
  );
}

infoSnack(BuildContext context, String message) {
  showTopSnackBar(
    context,
    CustomSnackBar.info(
      message: message,
    ),
    displayDuration: Duration(seconds: 2),
  );
}

notificationSnack(BuildContext context,String message){
  showTopSnackBar(
    context,
    CustomSnackBar.info(
        message: message,
    icon: Icon(Icons.notifications),
      iconRotationAngle: 0,
    ),
    displayDuration: Duration(seconds: 2),
  );
}
