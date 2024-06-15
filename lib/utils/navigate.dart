import 'package:flutter/material.dart';

class Navigate {
  static void push(BuildContext context, Widget widget) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: ((context) => widget)));
  }

  static void pop(BuildContext context) {
    Navigator.of(context).pop();
  }
}
