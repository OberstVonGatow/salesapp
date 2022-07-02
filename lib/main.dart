// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salesapp/firebase_options.dart';
import 'package:salesapp/home/home.dart';
import 'package:salesapp/services/models.dart';
import 'package:salesapp/services/provider.dart';
import 'package:salesapp/shared/error.dart';
import 'package:salesapp/shared/loading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'routes.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

/// We are using a StatefulWidget such that we only create the [Future] once,
/// no matter how many times our widget rebuild.
/// If we used a [StatelessWidget], in the event where [App] is rebuilt, that
/// would re-initialize FlutterFire and make our application re-enter loading state,
/// which is undesired.
class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);
  // Create the initialization Future outside of `build`:
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  /// The future is part of the state of our widget. We should not call `initializeApp`
  /// directly inside [build].
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return const MaterialApp(
              home: Center(
            child: ErrorMessage(),
          ));
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          // return StreamProvider(
          //   create:(_) => FirestoreService().streamReport(),
          //   initialData: Report(),
          //   child: MaterialApp(
          //     routes: appRoutes,
          //     theme: appTheme,
          //   ),
          // );
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => CurrentOrder()),
              ChangeNotifierProvider(create: (_) => Customers()),
              ChangeNotifierProvider(create: (_) => UserDataProvider()),
            ],
            child: MaterialApp(
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en', ''),
                Locale('de', ''),
              ],
              routes: appRoutes,
              theme: appTheme,
              home: const HomeScreen(),
            ),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return const MaterialApp(home: LoadingScreen());
      },
    );
  }
}
