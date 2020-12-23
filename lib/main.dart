import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gimig_gastro_image_upload/screens/display_screen.dart';
import 'package:gimig_gastro_image_upload/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'route_generator.dart';
import 'screens/authentication/login_screen.dart';
import 'screens/upload_screen.dart';
import 'services/authentication_servie.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
        )
      ],
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: 'Roboto',
        ).copyWith(
          accentColor: Colors.tealAccent,
        ),
        onGenerateRoute: RouteGenerator.generateRoute,
        initialRoute: AuthenticationWrapper.id,
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  static const String id = 'auth_screen';
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    if (firebaseUser != null) {
      return HomeScreen();
    }
    return LoginScreen();
  }
}
