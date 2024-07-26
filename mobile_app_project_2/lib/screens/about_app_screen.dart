// lib/screens/about_app_screen.dart

import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Artfolio'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Artfolio',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 16),
            Text(
              'Version 1.0.0',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 24),
            Text(
              'Artfolio is a mobile app designed to empower artists by providing a platform to showcase their creative work, connect with potential clients, and receive valuable feedback.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 24),
            Text(
              'Features:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 8),
            _buildFeatureItem(context, 'Showcase your artwork'),
            _buildFeatureItem(context, 'Discover other artists'),
            _buildFeatureItem(context, 'Receive feedback on your work'),
            _buildFeatureItem(context, 'Connect with potential clients'),
            SizedBox(height: 24),
            Text(
              '© 2024 Artfolio. All rights reserved.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, String feature) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.check, size: 20),
          SizedBox(width: 8),
          Text(feature, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
