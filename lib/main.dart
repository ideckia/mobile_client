import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keep_screen_on/keep_screen_on.dart';

import 'view/LookForServerView.dart';

Future<void> main() async {
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
  KeepScreenOn.turnOn();
  SystemChrome.setEnabledSystemUIOverlays([]);
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
        primaryColor: Colors.grey,
        primarySwatch: Colors.grey,
        fontFamily: 'Ubuntu',
        primaryTextTheme: TextTheme(
          headline6: TextStyle(
            color: textColor,
          ),
        ),
        primaryIconTheme: const IconThemeData.fallback().copyWith(
          color: textColor,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            onPrimary: textColor,
          ),
        ),
        textTheme: TextTheme(
          bodyText1: TextStyle(),
          bodyText2: TextStyle(),
        ).apply(
          bodyColor: textColor,
        ),
      ),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: LookForServerView(),
    );
  }
}
