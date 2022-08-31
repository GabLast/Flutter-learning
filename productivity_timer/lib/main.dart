import 'dart:async';

import 'package:flutter/material.dart';
import 'package:productivity_timer/settings.dart';
import 'package:productivity_timer/timer.dart';
import 'package:productivity_timer/widgets.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:productivity_timer/models/Timer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: TimerHomePage(),
    );}
}

class TimerHomePage extends StatelessWidget {

  final CountDownTimer timer = CountDownTimer();

  @override
  Widget build(BuildContext context) {

    final padding = Padding(padding: const EdgeInsets.all(5.0));
    final List<PopupMenuItem<String>> menuItems = <PopupMenuItem<String>>[];
    menuItems.add(PopupMenuItem(
      value: 'Settings',
      child: Text('Settings'),
    ));

    timer.startWork();

    return Scaffold(
        appBar: AppBar(
          title: Text('Work timer'),
          actions: [
            PopupMenuButton<String>(
              itemBuilder: (BuildContext context) {
                return menuItems.toList();
              },
              onSelected: (s) {
                if(s=='Settings') {
                  goToSettings(context);
                }
              },
            )
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final double availableWidth = constraints.maxWidth;
            return Column(
                children: [
                  Row(
                    children: [
                      padding,
                      Expanded(child: ProductivityButton(color: Color(0xff009688),
                          text: "Work", onPressed: () => timer.startWork())),
                      padding,
                      Expanded(child: ProductivityButton(color: Color(0xff607D8B),
                          text: "Short Break",onPressed: () => timer.startBreak(true))),
                      padding,
                      Expanded(child: ProductivityButton(color: Color(0xff455A64),
                          text: "Long Break", onPressed: () => timer.startBreak(false))),
                      padding,
                    ],
                  ),
                  Expanded(
                      child: StreamBuilder(
                          initialData: Timer('00:00', 1),
                          stream: timer.stream(),
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                            Timer timer = snapshot.data;
                            return Center(
                              child: SingleChildScrollView(
                                  child: CircularPercentIndicator(
                                    radius: availableWidth/2,
                                    lineWidth: 20.0,
                                    percent: (timer.percent == null) ? 1 : timer.percent,
                                    center: Text( (timer.time == null) ? '00:00' : timer.time ,
                                        style: Theme.of(context).textTheme.headline4),
                                    progressColor: Color(0xff009688),
                                  )
                              ),
                            );
                          })),
                  Row(children: [
                    padding,
                    Expanded(child: ProductivityButton(color: Color(0xff212121), text: 'Stop', onPressed: () => timer.stopTimer())),
                    padding,
                    Expanded(child: ProductivityButton(color: Color(0xff009688), text: 'Resume', onPressed: () => timer.startTimer())),
                    padding
                  ],)
                ]);
          },
        )

    );
  }

  void goToSettings(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SettingsScreen()));
  }
}
