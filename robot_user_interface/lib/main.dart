import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:robot_user_interface/app_styles.dart';
import 'package:robot_user_interface/screens/credentials_screen.dart';
import 'package:robot_user_interface/screens/pairing_screen.dart';
import 'package:robot_user_interface/screens/simulation_screen.dart';
import 'package:robot_user_interface/screens/user_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    MyApp(),
  );
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return MaterialApp(
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(
              color: AppStyles.generalColors['secondary'], // Appbar arrow color
            ),
            backgroundColor: AppStyles.generalColors['primary'],
            foregroundColor: AppStyles.generalColors['primary'],
          ),
          scaffoldBackgroundColor:
              AppStyles.generalColors['scaffoldBackground'],
        ),
        navigatorKey: navigatorKey,
        title: 'Robot UI',
        routes: {
          '/': (context) => CredentialsScreen(),
          '/pairing_screen': (context) => PairingScreen(),
          '/simulation_screen': (context) => SimulationScreen(),
          '/user_screen': (context) => UserScreen(),
        },
        debugShowCheckedModeBanner: false,
      );
    });
  }
}
