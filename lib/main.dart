import 'package:flutter/material.dart';
import 'package:stt_tts/Shared/home/home.dart';
import 'package:stt_tts/tts/tts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      // ),
      home: const App(),
    );
  }
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => AppState();
}

class AppState extends State<App> {
  int selectedPageIndex = 0;

  final List<Widget> page = [HomePage(), TTSPage()];

  final List<String> pageTitle = ["Home", "Text to speech"];

  // Page icons.
  Icon pageIcon(int index) {
    switch (index) {
      case 0:
        return const Icon(Icons.home);
      case 1:
        return const Icon(Icons.record_voice_over);
      default:
        return const Icon(Icons.pages);
    }
  }

  // function to select pages.
  void selectPage(int index) {
    setState(() {
      selectedPageIndex = index;
    });
    Navigator.canPop(context); // this will display the page.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("STT and TTS")),
      // drawer: Drawer(
      //   child: ListView(
      //     padding: EdgeInsets.all(0),
      //     children: [
      //       DrawerHeader(
      //         decoration: BoxDecoration(color: Colors.blueAccent),
      //         child: Text(
      //           "Recent Activity",
      //           style: TextStyle(color: Colors.white, fontSize: 24),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      body: page[selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedPageIndex,
        onTap: selectPage,
        items: [
          // loop the array of page.
          for (int i = 0; i < pageTitle.length; i++)
            BottomNavigationBarItem(icon: pageIcon(i), label: pageTitle[i]),
        ],
      ),
    );
  }
}
