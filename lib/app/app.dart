import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tick_tock/modules/home/ui/home_page.dart';
import 'config.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ));
        return MaterialApp(
          themeMode: ThemeMode.system,
          theme: ThemeData(
            colorScheme: lightDynamic,
            textTheme: GoogleFonts.interTextTheme(),
          ),
          darkTheme: ThemeData(
            colorScheme: darkDynamic,
            textTheme: GoogleFonts.interTextTheme(),
          ),
          home: const MyHomePage(),
        );
      },
    );
  }
}
