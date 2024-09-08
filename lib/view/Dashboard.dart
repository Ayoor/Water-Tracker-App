import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:water_tracker/ViewModel/DashboardProvider.dart';
import '../CustomDialogue.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final dvm = Provider.of<DashboardProvider>(context, listen: false);
    dvm.loadCurrentWaterIntakeStatus();
    dvm.retrieveWeeklyHistoryData();
    _controller.text = dvm.currentNumber.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const Text(
                        "Today",
                        style: TextStyle(color: Colors.blue, fontSize: 40),
                      ),
                      Text(
                        DateFormat.yMMMMd().format(DateTime.now()),
                        style: const TextStyle(fontSize: 16, color: Colors.pink),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        "Next Drink Time",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Consumer<DashboardProvider>(
                        builder: (context, provider, child) => Text(
                          provider.dueDate,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.pink),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 400,
              child: Center(
                child: Consumer<DashboardProvider>(
                  builder: (context, provider, child) =>
                      CircularPercentIndicator(
                        radius: 150,
                        percent: provider.indicatorPercentage,
                        progressColor: Colors.blue,
                        backgroundColor: Colors.blue.shade100,
                        circularStrokeCap: CircularStrokeCap.round,
                        addAutomaticKeepAlive: true,
                        animationDuration: 2000,
                        animateFromLastPercent: true,
                        animation: true,
                        lineWidth: 15,
                        center: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Drink Target",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 40,
                                  color: Colors.blue),
                            ),
                            Text(
                              "${provider.currentMill}/1500ml",
                              style: const TextStyle(fontSize: 17),
                            ),
                          ],
                        ),
                      ),
                ),
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.change_circle),
                  iconSize: 30,
                  color: Colors.blue,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => CustomAlertDialog(
                        onItemSelected: Provider.of<DashboardProvider>(context, listen: false).onItemSelected,
                      ),
                    );
                  },
                ),
                Consumer<DashboardProvider>(
                  builder: (context, provider, child) => Image.asset(
                    provider.imgPath,
                    width: 70,
                    height: 70,
                  ),
                ),
                Consumer<DashboardProvider>(
                  builder: (context, provider, child) => Text(
                    provider.cupMill,
                    style: const TextStyle(fontSize: 17),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        Provider.of<DashboardProvider>(context, listen: false)
                            .decrement();
                        _controller.text = Provider.of<DashboardProvider>(
                            context,
                            listen: false)
                            .currentNumber
                            .toString();
                      },
                    ),
                    SizedBox(
                      width: 60,
                      child: TextField(
                        controller: _controller,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          Provider.of<DashboardProvider>(context,
                              listen: false)
                              .onChanged(value);
                          _controller.text =
                              Provider.of<DashboardProvider>(context,
                                  listen: false)
                                  .currentNumber
                                  .toString();
                        },
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 8),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        Provider.of<DashboardProvider>(context, listen: false)
                            .increment();
                        _controller.text = Provider.of<DashboardProvider>(
                            context,
                            listen: false)
                            .currentNumber
                            .toString();
                      },
                    ),
                  ],
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  Provider.of<DashboardProvider>(context, listen: false)
                      .drink();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 70),
                  backgroundColor: Colors.blue,
                ),
                child: const Text(
                  "Drink",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
