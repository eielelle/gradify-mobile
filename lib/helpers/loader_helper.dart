import 'package:flutter/material.dart';

class LoaderHelper {
  static Widget showLoading() {
    return SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(color: Colors.white),
    );
  }
}
