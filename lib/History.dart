import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'DrinkHistoryProvider.dart';
import 'Model/CupData.dart';

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
    // Load drink history when the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DrinkHistoryProvider>().loadDrinkHistory();
    });
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
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Tab 1 - Today
                  Consumer<DrinkHistoryProvider>(
                    builder: (context, provider, child) {
                      return ListView.builder(
                        itemCount: provider.drinkHistory.length,
                        itemBuilder: (context, index) {
                          final drinkData = provider.drinkHistory[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              // Background color for the container
                              borderRadius: BorderRadius.circular(10.0), // Set border radius
                              border: Border.all(
                                // Define border properties
                                color: Colors.blueGrey, // Border color
                                width: 1.0, // Border width
                              ),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(12),
                              tileColor: Colors.transparent, // Make ListTile transparent (optional)
                              leading: Image.asset(drinkData.cupData.image),
                              title: Text("You drank ${drinkData.cupData.cupMlText} at ${drinkData.time} "),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  // Tab 2 - Past Week (You can implement the past week functionality similarly)
                  const Center(
                    child: Text(
                      "Content for Tab 2",
                      style: TextStyle(fontSize: 25, color: Colors.blue),
                    ),
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
