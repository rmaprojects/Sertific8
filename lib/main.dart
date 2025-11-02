import 'package:sertific8/components/window_bar.dart';
import 'package:sertific8/routes/go_routes.dart';
import 'package:window_manager/window_manager.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(800, 600),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
    fullScreen: false,
    windowButtonVisibility: false
  );

  WindowManager.instance.setMaximumSize(Size(800, 720));
  WindowManager.instance.setMinimumSize(Size(500, 600));
  WindowManager.instance.setFullScreen(false);

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Sertific8',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
      ),
      scrollBehavior: CupertinoScrollBehavior(),
      routerConfig: appRoute,
      builder: (context, child) => Scaffold(
        appBar: const WindowBar(),
        body: child!,
      ),
    );
  }
}
