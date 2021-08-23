import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/workouts_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

import './providers/auth.dart';
import './providers/exercises.dart';
import 'providers/workoutplan.dart';
import './screens/auth_screen.dart';
import './screens/splash_screen.dart';
import './screens/calendar_screen.dart';
import './screens/exercises_screen.dart';
import './helpers/custom_route.dart';

void main() async {
  await DotEnv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, WorkoutPlan>(
          create: (ctx) => WorkoutPlan('', ''),
          update: (ctx, auth, previousProducts) => WorkoutPlan(
            auth.token,
            auth.userId,
          ),
        ),
        ChangeNotifierProvider(create: (ctx) => Exercises()),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Woryx App',
          theme: ThemeData(
            primarySwatch: Colors.red,
            accentColor: Colors.amber,
            fontFamily: 'Lato',
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder(),
              },
            ),
          ),
          home: auth.isAuth
              ? CalendarScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ListExercisesScreen.routeName: (ctx) => ListExercisesScreen(),
            WorkoutsScreen.routeName: (ctx) => WorkoutsScreen(),
          },
        ),
      ),
    );
  }
}
