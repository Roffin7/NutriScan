import 'package:flutter/material.dart';
import '../widgets/food_card.dart';

class DetailsScreen extends StatelessWidget {
  final List<dynamic> foodData;

  DetailsScreen({required this.foodData});

  @override
  Widget build(BuildContext context) {
    // Add debug print to check the data
    print('Food Data Length: ${foodData.length}');
    print('Food Data: $foodData');

    return Scaffold(
      appBar: AppBar(
        title: Text('Food Details'),
        backgroundColor: Colors.green,
      ),
      body: foodData.isEmpty
          ? Center(
              child: Text(
                'No food items found',
                style: TextStyle(fontSize: 18),
              ),
            )
          : Padding(
              padding: EdgeInsets.all(16),
              child: ListView.builder(
                itemCount: foodData.length,
                itemBuilder: (context, index) {
                  // Add debug print for each item
                  print('Item $index: ${foodData[index]}');
                  
                  // Ensure the foodItem is a Map
                  if (foodData[index] is! Map) {
                    print('Warning: Item $index is not a Map');
                    return SizedBox.shrink(); // Return empty widget if not a map
                  }

                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: FoodCard(foodItem: foodData[index]),
                  );
                },
              ),
            ),
    );
  }
}