import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Log.dart';
import 'view/LookForCoreView.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();

    runApp(
      EasyLocalization(
        supportedLocales: [
          Locale('eu'),
          Locale('en'),
          Locale('es'),
          Locale('fr')
        ],
        path: 'assets/translations',
        fallbackLocale: Locale('en'),
        child: Ideckia(),
      ),
    );
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }, (dynamic error, StackTrace stacktrace) {
    Log.error("Unhandled error", error);
    Fluttertoast.showToast(
      msg: 'Unhandled error: $error',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.deepOrangeAccent,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  });
}

class Ideckia extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var textColor = Colors.yellowAccent;
    return MaterialApp(
      title: 'Ideckia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.grey.shade700,
        splashColor: Colors.yellowAccent.shade400.withAlpha(128),
        primaryColor: Colors.grey,
        primarySwatch: Colors.grey,
        fontFamily: 'Ubuntu',
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
            color: textColor,
            fontFamily: 'Ubuntu',
            fontSize: 22,
          ),
        ),
        primaryIconTheme: const IconThemeData.fallback().copyWith(
          color: textColor,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: textColor,
          ),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(),
          bodyMedium: TextStyle(),
        ).apply(
          bodyColor: textColor,
        ),
      ),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: LookForCoreView(),
    );
  }
}
