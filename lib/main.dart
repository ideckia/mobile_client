import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'view/LookForIpView.dart';

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
        path:
            'assets/translations', // <-- change the path of the translation files
        fallbackLocale: Locale('en'),
        child: Ideckia()),
  );
  SystemChrome.setEnabledSystemUIOverlays([]);
}

class Ideckia extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ideckia',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey.shade700,
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: LookForIpView(),
    );
  }
}
