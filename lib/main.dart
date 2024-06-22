import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/event_form_screen.dart';
import 'screens/events_screen.dart';
import 'screens/check_in_screen.dart';
import 'screens/event_details_screen.dart';
import 'screens/invite_screen.dart';
import 'screens/team_sign_up_screen.dart';
import 'screens/feed_screen.dart';
import 'screens/messaging_screen.dart';
import 'color_palette.dart';
import 'event_updater.dart'; // Import the EventUpdater

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  EventUpdater().start(); // Start the EventUpdater
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sports App',
      theme: ThemeData(
        primaryColor: ColorPalette.primaryColor,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: ColorPalette.secondaryColor,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.hovered)) {
                  return ColorPalette.primaryLight; // Light Blue on hover
                }
                if (states.contains(MaterialState.pressed)) {
                  return ColorPalette.primaryDark; // Dark Blue on click
                }
                return ColorPalette.primaryColor; // Default blue button color
              },
            ),
            foregroundColor: MaterialStateProperty.all<Color>(ColorPalette.white), // Button text color
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            padding: MaterialStateProperty.all<EdgeInsets>(
              EdgeInsets.symmetric(vertical: 15, horizontal: 30),
            ),
            elevation: MaterialStateProperty.all<double>(5), // Always have shadow
            shadowColor: MaterialStateProperty.all<Color>(
              Colors.black.withOpacity(0.2),
            ),
            overlayColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.hovered)) {
                  return ColorPalette.white.withOpacity(0.2); // Overlay color on hover
                }
                if (states.contains(MaterialState.pressed)) {
                  return ColorPalette.white.withOpacity(0.3); // Overlay color on click
                }
                return Colors.transparent; // Default overlay color
              },
            ),
            animationDuration: Duration(milliseconds: 150),
            enableFeedback: true,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: ColorPalette.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: ColorPalette.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: ColorPalette.primaryColor),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: ColorPalette.red),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        scaffoldBackgroundColor: ColorPalette.white, // Light Background
        cardTheme: CardTheme(
          color: ColorPalette.white,
          shadowColor: Colors.black.withOpacity(0.2),
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: ColorPalette.primaryColor, // Cool Blue
          titleTextStyle: TextStyle(
            color: ColorPalette.white,
            fontSize: 20,
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => AuthScreen(),
        '/home': (context) => HomeScreen(),
        '/event_form': (context) => EventFormScreen(),
        '/events': (context) => EventsScreen(),
        '/check_in': (context) => CheckInScreen(eventId: ''),
        '/event_details': (context) => EventDetailsScreen(eventId: ''),
        '/invite': (context) => InviteScreen(eventId: ''),
        '/team_sign_up': (context) => TeamSignUpScreen(eventId: ''),
        '/feed': (context) => FeedScreen(),
        '/messaging': (context) => MessagingScreen(),
      },
    );
  }
}
