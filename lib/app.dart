import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/single_child_widget.dart';
import 'package:weather/controller/providers/location.dart';
import 'package:weather/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:weather/view/init/splash_screen.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weather',
        theme: ThemeData(
          appBarTheme: appBarTheme(),
          primaryColor: theme,
          splashColor: theme.withOpacity(0.25),
          highlightColor: theme.withOpacity(0.25),
          scaffoldBackgroundColor: theme,
          textTheme: GoogleFonts.mavenProTextTheme(),
          textSelectionTheme: const TextSelectionThemeData(cursorColor: white),
        ),
        home: const SplashScreen(),
      ),
    );
  }

  AppBarTheme appBarTheme() {
    return AppBarTheme(
      foregroundColor: white,
      elevation: 0,
      backgroundColor: theme,
      centerTitle: true,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: theme,
        statusBarIconBrightness: Brightness.light,
      ),
      iconTheme: const IconThemeData(color: white),
      titleTextStyle: GoogleFonts.nunito(
        textStyle: const TextStyle(
          color: theme,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
        ),
      ),
    );
  }

  List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (context) {
      LocationProvider lp = LocationProvider();
      lp.inception();
      lp.getListOfCities(context);
      return lp;
    }),
  ];
}
