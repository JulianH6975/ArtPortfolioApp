// lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/login_signup_screen.dart';
import 'screens/main_screen.dart';
import 'screens/upload_art_screen.dart';
import 'screens/artwork_screen.dart';
import 'screens/edit_profile_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/artist_profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/foundation.dart';
import 'screens/about_app_screen.dart';
import 'screens/profile_setup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kDebugMode) {
    debugPrintLayouts = true;
    debugPaintSizeEnabled = true;
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Artfolio',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginSignupScreen(),
        '/main': (context) => MainScreen(),
        '/upload': (context) => UploadArtScreen(),
        '/edit_profile': (context) => EditProfileScreen(),
        '/profile_setup': (context) => ProfileSetupScreen(),
        '/about': (context) => AboutAppScreen(),
        '/settings': (context) => SettingsScreen(),
        '/profile': (context) =>
            ArtistProfileScreen(userId: FirebaseAuth.instance.currentUser?.uid),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/artwork') {
          final args = settings.arguments;
          if (args is String) {
            return MaterialPageRoute(
              builder: (context) => ArtworkScreen(artworkId: args),
            );
          }
          return MaterialPageRoute(
            builder: (context) => const Scaffold(
              body: Center(
                child: Text('Error: Invalid artwork ID'),
              ),
            ),
          );
        }
        return null;
      },
    );
  }
}
