import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/event_form.dart';
import 'screens/events_screen.dart';
import 'screens/check_in_screen.dart';
import 'screens/event_details_screen.dart';
import 'screens/invite_screen.dart';
import 'screens/team_sign_up_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sports App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => AuthScreen(),
        '/home': (context) => MyHomePage(),
        '/event_form': (context) => EventForm(),
        '/events': (context) => EventsScreen(),
        '/check_in': (context) => CheckInScreen(eventId: ''),
        '/event_details': (context) => EventDetailsScreen(eventId: ''),
        '/invite': (context) => InviteScreen(eventId: ''),
        '/team_sign_up': (context) => TeamSignUpScreen(eventId: ''),
      },
    );
  }
}
