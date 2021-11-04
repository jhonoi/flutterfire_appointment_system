import 'package:flutter/material.dart';
import 'package:web_app_firebase/appointment.dart';
import 'package:web_app_firebase/screens/appointments_screen.dart';
import 'package:web_app_firebase/screens/details_screen.dart';
import 'package:web_app_firebase/screens/home_screen.dart';
import 'package:web_app_firebase/screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

/// We are using a StatefulWidget such that we only create the [Future] once,
/// no matter how many times our widget rebuild.
/// If we used a [StatelessWidget], in the event where [App] is rebuilt, that
/// would re-initialize FlutterFire and make our application re-enter loading state,
/// which is undesired.
class App extends StatefulWidget {
  // Create the initialization Future outside of `build`:
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        accentColor: Colors.blue[400],
        primaryTextTheme: TextTheme(
          headline1: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.normal),
        ),
      ),
      onGenerateRoute: (settings) {
        // Handle '/'
        if (settings.name == '/') {
          return MaterialPageRoute(
            settings: settings,
            builder: (context) => HomeScreen(),
          );
        }

        // Handle '/login
        if (settings.name == '/login') {
          final args = settings.arguments as Appointment;
          return MaterialPageRoute(
            settings: settings,
            builder: (context) => LoginScreen(appointment: args),
          );
        }

        // Handle '/appointments
        if (settings.name == '/appointments') {
          return MaterialPageRoute(
            settings: settings,
            builder: (context) => AppointmentsScreen(),
          );
        }

        // Handle '/details/:id'
        var uri = Uri.parse(settings.name);
        if (uri.pathSegments.length == 2 &&
            uri.pathSegments.first == 'details') {
          var id = uri.pathSegments[1];
          return MaterialPageRoute(
            settings: settings,
            builder: (context) => DetailsScreen(id: id),
          );
        }

        return MaterialPageRoute(
          settings: settings,
          builder: (context) => UnknownScreen(),
        );
      },
    );
  }
}

class UnknownScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      width: double.infinity,
      height: double.infinity,
      child: Center(child: Text('NO PAGE FOUND')),
    );
  }
}
