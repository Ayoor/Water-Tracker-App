import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_tracker/ViewModel/DashboardProvider.dart';
import 'package:water_tracker/widgets/chart.dart';
import '../Model/historyData.dart';
import '../ViewModel/DrinkHistoryProvider.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Provider.of<DrinkHistoryProvider>(context, listen: false)
        .loadDrinkHistory();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "History",
          style: TextStyle(color: Colors.white),
        ),
        bottom: TabBar(
          indicatorColor: Colors.orange,
          indicatorSize: TabBarIndicatorSize.tab,
          controller: _tabController,
          tabs: const [
            Tab(
              child: Text("Today", style: TextStyle(color: Colors.white)),
            ),
            Tab(
              child: Text("Past Week", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
      body: TabBarView(
          controller: _tabController,
          children: [
      // Tab 1 - Today
      Consumer<DrinkHistoryProvider>(
      builder: (context, provider, child) {
    provider.loadDrinkHistory();
    if (provider.drinkHistory.isEmpty) {
    return const Center(
    child: Text("No drinks for today yet, Drink a glass and get Hydrated"),
    );
    }
    else {
    return Padding(
    padding: const EdgeInsets.all(15.0),
    child: ListView.builder(
    itemCount: provider.drinkHistory.length,
    itemBuilder: (context, index) {
    final drinkData = provider.drinkHistory[index];
    return Container(
    margin: const EdgeInsets.only(bottom: 20),
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
    color: Colors.blueGrey, width: 1.0),
    ),
    child: ListTile(
    contentPadding: const EdgeInsets.all(12),
    leading: Image.asset(drinkData.cupData.image),
    title: Text(
    "You drank ${drinkData.cupData
        .cupMlText} at ${drinkData.time} ",
    ),
    ),
    );
    },
    ),
    );
    }
    },
    ),

    // Tab 2 - Past Week
    Center(
    child: Padding(
    padding: const EdgeInsets.all(15.0),
    child: SizedBox(
    height: MediaQuery.of(context).size.height / 2.5,
    // child: AnimatedBarGraph(),
    child: Consumer<DrinkHistoryProvider>( builder: (context, provider, child) {
      final dashhboardProvider = Provider.of<DashboardProvider>(context, listen: false);
      dashhboardProvider.retrieveWeeklyHistoryData();
      return const AnimatedBarGraph();}
    ),
    ),
    ),
    ),
    ],
    ),
    );
  }

}
