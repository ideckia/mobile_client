import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_logs/flutter_logs.dart';

import 'view/LookForIpView.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  //Initialize Logging
  await FlutterLogs.initLogs(
      logLevelsEnabled: [
        LogLevel.INFO,
        LogLevel.WARNING,
        LogLevel.ERROR,
        LogLevel.SEVERE
      ],
      timeStampFormat: TimeStampFormat.TIME_FORMAT_READABLE,
      directoryStructure: DirectoryStructure.FOR_DATE,
      logTypesEnabled: ["device", "network", "errors"],
      logFileExtension: LogFileExtension.LOG,
      logsWriteDirectoryName: "logs",
      logsExportDirectoryName: "logs/Exported",
      debugFileOperations: true,
      isDebuggable: true);

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
