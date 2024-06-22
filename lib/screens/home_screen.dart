import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'event_form_screen.dart';
import 'friend_requests_screen.dart';
import '../components/custom_button.dart';
import '../components/dashboard.dart';
import '../components/events_list.dart';
import '../components/friends_list.dart';
import '../components/friend_requests_notification.dart';
import '../components/dashboard_button.dart'; // Make sure this import is added
import '../color_palette.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        body: Center(
          child: Text("You need to sign in first."),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Sports App Home Page', style: Theme.of(context).textTheme.titleLarge),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Dashboard(buildDashboardButton: _buildDashboardButton),
              SizedBox(height: 20),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            child: CustomButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => EventFormScreen()));
                              },
                              text: 'Create Event',
                              color: ColorPalette.primaryColor,
                            ),
                          ),
                          SizedBox(height: 20),
                          Expanded(
                            child: EventsList(),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            child: CustomButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => FriendRequestsScreen()));
                              },
                              text: 'Find Friends',
                              color: ColorPalette.primaryColor,
                            ),
                          ),
                          SizedBox(height: 20),
                          Expanded(
                            child: FriendsList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardButton(String label, IconData icon, Widget screen, Color color) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DashboardButton(label: label, icon: icon, screen: screen, color: color),
    );
  }
}
