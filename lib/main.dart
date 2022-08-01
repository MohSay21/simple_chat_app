import 'package:chat_app/ui/views/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/services/theme.dart';
import 'package:chat_app/ui/views/signin.dart';
import 'package:chat_app/ui/views/signup.dart';
import 'package:chat_app/ui/views/chat.dart';
import 'package:chat_app/ui/views/reset_password.dart';
import 'package:chat_app/ui/views/gallery.dart';
import 'package:chat_app/ui/views/main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

final navigatorKey = GlobalKey<NavigatorState>();
final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

class MyApp extends ConsumerWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
    Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Chat app',
      routes: {
        '/': (context) => MainV(),
        '/signin': (context) => SignInV(),
        '/signup': (context) => SignUpV(),
        '/reset': (context) => ResetPasswordV(),
        '/chat': (context) => const ChatV(),
        '/gallery': (context) => const GalleryV(),
        '/edit': (context) => const EditProfile(),
      },
      initialRoute: '/',
      themeMode: ref.watch(isDarkP) ? ThemeMode.dark : ThemeMode.light,
      darkTheme: MyTheme.dark,
      theme: MyTheme.light,
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: scaffoldKey,
      debugShowCheckedModeBanner: false,
    );
  }

}