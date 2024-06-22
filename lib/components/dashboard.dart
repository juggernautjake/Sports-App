import 'package:flutter/material.dart';
import '../screens/feed_screen.dart';
import '../screens/messaging_screen.dart';
import '../color_palette.dart';

class Dashboard extends StatelessWidget {
  final Function(String label, IconData icon, Widget screen, Color color) buildDashboardButton;

  Dashboard({required this.buildDashboardButton});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Dashboard', style: Theme.of(context).textTheme.titleLarge),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildDashboardButton('Feed', Icons.rss_feed, FeedScreen(), ColorPalette.secondaryColor),
            buildDashboardButton('Messaging', Icons.message, MessagingScreen(), ColorPalette.secondaryColor),
          ],
        ),
      ],
    );
  }
}
