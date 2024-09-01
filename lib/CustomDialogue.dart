import 'package:flutter/material.dart';

import 'Model/CupData.dart';

class CustomAlertDialog extends StatelessWidget {
  final Function(CupData) onItemSelected;

  CustomAlertDialog({required this.onItemSelected, super.key});

  @override
  Widget build(BuildContext context) {
    final List<CupData> items = [
      CupData(image: 'Assets/water100.png', cupMlText: '100ml', cupMil: 100),
      CupData(image: 'Assets/water200.png', cupMlText: '200ml', cupMil: 200),
      CupData(image: 'Assets/water300.png', cupMlText: '300ml', cupMil: 300),
      CupData(image: 'Assets/water400.png', cupMlText: '400ml', cupMil: 400),
      CupData(image: 'Assets/water500.png', cupMlText: '500ml', cupMil: 500),
    ];

    return AlertDialog(
      title: const Center(
        child: Text(
          'Change cup size',
          style: TextStyle(fontSize: 17),
        ),
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: double.maxFinite,
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              childAspectRatio: 1.0,
            ),
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  onItemSelected(items[index]);
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      items[index].image,
                      height: 70,
                      width: 70,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 8),
                    Text(items[index].cupMlText),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
