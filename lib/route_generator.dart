import 'package:flutter/material.dart';

import 'main.dart';
import 'screens/authentication/login_screen.dart';
import 'screens/authentication/registration_screen.dart';
import 'screens/display_screen.dart';
import 'screens/upload_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case AuthenticationWrapper.id:
        return MaterialPageRoute(builder: (_) => AuthenticationWrapper());

      case UploadScreen.id:
        return MaterialPageRoute(builder: (_) => UploadScreen());

      case DisplayScreen.id:
        return MaterialPageRoute(builder: (_) => DisplayScreen());

      case LoginScreen.id:
        return MaterialPageRoute(builder: (_) => LoginScreen());

      case RegistrationScreen.id:
        return MaterialPageRoute(builder: (_) => RegistrationScreen());

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: Text("ERROR"),
          ),
        );
      },
    );
  }
}
