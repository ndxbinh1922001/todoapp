import 'package:flutter/material.dart';
import 'package:to_do_app/Route/route.dart';
import 'package:to_do_app/UI/CreateCheckList.dart';
import 'package:to_do_app/UI/CreateNode.dart';
import 'package:to_do_app/UI/CreateTask.dart';
import 'package:to_do_app/UI/Walkthrough.dart';
import 'package:to_do_app/UI/Walkthrough1.dart';
import 'package:to_do_app/UI/SignIn.dart';
import 'package:to_do_app/UI/ForgotPassword.dart';
import 'package:to_do_app/UI/ResetPassword.dart';
import 'package:to_do_app/UI/Successfull.dart';
class RouteGenerator {
  static RouteGenerator? _instance;

  RouteGenerator._();

  factory RouteGenerator() {
    _instance ??= RouteGenerator._();
    return _instance!;
  }

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.Walkthrough :
        return MaterialPageRoute(builder: (_) => Walkthrough());
      case Routes.Walkthrough1 :
        return MaterialPageRoute(builder: (_) => Walkthrough1());
      case Routes.SignIn :
        return MaterialPageRoute(builder: (_) => SignIn());
      case Routes.ForgotPassword :
        return MaterialPageRoute(builder: (_) => ForgotPassword());
      case Routes.Successfull :
        return MaterialPageRoute(builder: (_) =>Successfull());
      default:
        return MaterialPageRoute(builder: (_) => Walkthrough());
    }
  }
}