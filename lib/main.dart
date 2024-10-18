import 'package:flutter/material.dart';
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
  const MyApp({super.key});

// Fonction pour construire l'application
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
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Variables pour la récupération de la météo
  String apiKey = '822f25ce79782c1d6d9562e2f66d5067'; // clé API OpenWeatherMap
  String city = 'Nantes'; // ville souhaitée
  var weatherData;

// Fonction pour récupérer la météo via l'API OpenWeatherMap
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
  }

// Fonction pour naviguer vers la page de l'alarme
  void _navigateToAlarmPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
    setState(() {});
  }

// Fonction pour naviguer vers la page du calendrier
  void _navigateToCalendarPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Calendar_Page()),
    );
    setState(() {});
  }

  // Fonction pour naviguer vers la page de l'événement
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 300,
              child: FutureBuilder(
                future: EventController.instance.getForDay(DateTime.now()),
                builder: (context, AsyncSnapshot<List<Event>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return Text('Erreur lors du chargement');
                  }

                  ValueNotifier<List<Event>> selectedEvents = ValueNotifier(snapshot.data ?? []);
                  return ValueListenableBuilder<List<Event>>(
                    valueListenable: selectedEvents,
                    builder: (context, value, _) {
                      return ListView.builder(
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: CalendarEvent(event: value[index]),
                        );
                      },
                    );
                  });
                },
              ),
            ),
            SizedBox(
              height: 250,
              // Section pour afficher la météo
              child: weatherData == null
                  ? const CircularProgressIndicator()
                  : Column(
                      children: [
                        Text(
                          'Météo à $city',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Text(
                          '${weatherData['main']['temp']}°C',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        Text(
                          '${weatherData['weather'][0]['description']}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          'Humidité: ${weatherData['main']['humidity']}%',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
            ),
            ],
        ),
        ),
        );
  }
}
