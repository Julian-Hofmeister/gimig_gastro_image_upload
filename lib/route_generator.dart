import 'package:flutter/material.dart';
import 'package:gimig_gastro_image_upload/screens/category_screen.dart';
import 'package:gimig_gastro_image_upload/screens/create_category_screen.dart';

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

      case CategoryScreen.id:
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => CategoryScreen(
              path: args,
            ),
          );
        }
        return _errorRoute();

      case CreateCategoryScreen.id:
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => CreateCategoryScreen(
              path: args,
            ),
          );
        }
        return _errorRoute();

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
