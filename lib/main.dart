import 'package:flutter/material.dart';
import 'widgets/infos_fenetre.dart';
import 'package:y_alarm/calendar/models/event.dart';
import 'package:y_alarm/calendar/service/event_controller.dart';

import 'package:y_alarm/calendar/widget/Calendar_page.dart';
import 'package:y_alarm/calendar/widget/calendar_event.dart';
import 'package:y_alarm/alarm/screens/home_screen.dart';

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
                    return Text('Error: ${snapshot.error}');
                  }

                  ValueNotifier<List<Event>> _selectedEvents = ValueNotifier(snapshot.data ?? []);
                  return ValueListenableBuilder<List<Event>>(
                    valueListenable: _selectedEvents,
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
            Expanded(child: GetFenetre()),
          ],
        ),
      ),
    );
  }
}