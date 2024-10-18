import 'package:flutter/material.dart';
import 'widgets/infos_fenetre.dart';
import 'package:y_alarm/calendar/models/event.dart';
import 'package:y_alarm/calendar/service/event_controller.dart';

import 'package:y_alarm/calendar/widget/Calendar_page.dart';
import 'package:y_alarm/calendar/widget/calendar_event.dart';
import 'package:y_alarm/alarm/screens/home_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (settings) {
        return null;
      },
      title: 'Y-Alarm',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(title: 'Y-Alarm'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String apiKey = '822f25ce79782c1d6d9562e2f66d5067'; // clé API OpenWeatherMap
  String city = 'Nantes'; // ville souhaitée
  var weatherData;

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  // Fonction pour récupérer la météo via l'API OpenWeatherMap
  Future<void> fetchWeather() async {
    var url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric&lang=fr',
    );
    var response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        weatherData = json.decode(response.body);
      });
    } else {
      print('Erreur lors de la récupération des données météo');
    }
class _HomePageState extends State<HomePage> {
  
  void _navigateToCalendarPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Calendar_Page()),
    );
    setState(() {});
  }

  void _navigateToAlarmPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              _navigateToCalendarPage();
            },
          ),
          IconButton(
            icon: Icon(Icons.alarm),
            onPressed: () {
              _navigateToAlarmPage();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}