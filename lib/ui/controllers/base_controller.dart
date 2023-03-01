import 'package:flutter/material.dart';

class BaseController {
// the context here would be used by all models to access the various providers passed through the context.

  static late BuildContext context;

  static initContext(BuildContext context) {
    BaseController.context = context;
  }
}
