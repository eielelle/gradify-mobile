import 'package:flutter/material.dart';

class LoaderHelper {
  static Widget showLoading() {
    return SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(color: Colors.white),
    );
  }

  static void showDialogLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing the dialog
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(
            color: Colors.green,
          ),
        );
      },
    );
  }
}
