import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/login_signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/artist_profile_screen.dart';
import 'screens/artwork_screen.dart';
import 'screens/upload_art_screen.dart';
import 'screens/search_discover_screen.dart';

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
      title: 'Artfolio',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginSignupScreen(),
        '/home': (context) => HomeScreen(),
        '/profile': (context) => ArtistProfileScreen(),
        '/artwork': (context) => ArtworkScreen(),
        '/upload': (context) => UploadArtScreen(),
        '/search': (context) => SearchDiscoverScreen(),
      },
    );
  }
}
