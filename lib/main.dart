import 'package:chatbot/provider/message_provider.dart';
import 'package:chatbot/provider/theme_provider.dart';
import 'package:chatbot/screens/splash_screen.dart';
import 'package:chatbot/theme/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => MessageProvider())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final themeData = themeProvider.isDarkMode
        ? ApparenceKitThemeData.dark()
        : ApparenceKitThemeData.light();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: themeData.materialTheme,
      home: SplashScreen(),
    );
  }
}
