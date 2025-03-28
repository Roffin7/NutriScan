import 'package:flutter/material.dart';
import '../services/saved_foods_manager.dart';

class FoodCard extends StatefulWidget {
  final Map<String, dynamic> foodItem;

  FoodCard({required this.foodItem});

  @override
  _FoodCardState createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> {
  final SavedFoodsManager _savedFoodsManager = SavedFoodsManager();

  double estimateCalories() {
    double fat = double.tryParse(widget.foodItem["fat_total_g"]?.toString() ?? '0') ?? 0;
    double protein = widget.foodItem["protein_g"] == "Only available for premium subscribers." 
        ? 0 
        : (double.tryParse(widget.foodItem["protein_g"]?.toString() ?? '0') ?? 0);
    double carbs = double.tryParse(widget.foodItem["carbohydrates_total_g"]?.toString() ?? '0') ?? 0;
    return (fat * 9) + (protein * 4) + (carbs * 4);
  }

  double estimateProtein() {
    if (widget.foodItem["protein_g"] == "Only available for premium subscribers.") {
      return (double.tryParse(widget.foodItem["fat_total_g"]?.toString() ?? '0') ?? 0) * 0.1; // Rough estimation
    }
    return double.tryParse(widget.foodItem["protein_g"]?.toString() ?? '0') ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    double estimatedCalories = estimateCalories();
    double estimatedProtein = estimateProtein();
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header with Food Name and Save Button
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    (widget.foodItem["name"] ?? 'Unknown Food').toString().toUpperCase(),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade800,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add_circle, color: Colors.green.shade700, size: 30),
                  onPressed: () {
                    // Add to saved foods
                    _savedFoodsManager.addSavedFood(widget.foodItem);
                    
                    // Show a snackbar to confirm
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Food item saved!'),
                        duration: Duration(seconds: 2),
                        backgroundColor: Colors.green.shade700,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Nutrition Details
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nutrition Grid
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  childAspectRatio: 3,
                  children: [
                    _buildNutritionItem(
                      icon: Icons.fitness_center,
                      label: 'Fat',
                      value: '${widget.foodItem["fat_total_g"] ?? '0'}g',
                    ),
                    _buildNutritionItem(
                      icon: Icons.water_drop,
                      label: 'Sodium',
                      value: '${widget.foodItem["sodium_mg"] ?? '0'}mg',
                    ),
                    _buildNutritionItem(
                      icon: Icons.healing,
                      label: 'Potassium',
                      value: '${widget.foodItem["potassium_mg"] ?? '0'}mg',
                    ),
                    _buildNutritionItem(
                      icon: Icons.favorite,
                      label: 'Cholesterol',
                      value: '${widget.foodItem["cholesterol_mg"] ?? '0'}mg',
                    ),
                  ],
                ),

                SizedBox(height: 16),

                // Additional Nutrition Info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDetailChip(
                      label: 'Carbs',
                      value: '${widget.foodItem["carbohydrates_total_g"] ?? '0'}g',
                      color: Colors.orange.shade100,
                    ),
                    _buildDetailChip(
                      label: 'Fiber',
                      value: '${widget.foodItem["fiber_g"] ?? '0'}g',
                      color: Colors.green.shade100,
                    ),
                    _buildDetailChip(
                      label: 'Sugar',
                      value: '${widget.foodItem["sugar_g"] ?? '0'}g',
                      color: Colors.red.shade100,
                    ),
                  ],
                ),

                SizedBox(height: 16),

                // Calorie and Protein Summary
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSummaryCard(
                      title: 'Calories',
                      value: estimatedCalories.toStringAsFixed(2),
                      unit: 'kcal',
                      color: Colors.green.shade100,
                    ),
                    _buildSummaryCard(
                      title: 'Protein',
                      value: estimatedProtein.toStringAsFixed(2),
                      unit: 'g',
                      color: Colors.blue.shade100,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build nutrition grid items
  Widget _buildNutritionItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.green.shade700, size: 20),
        SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 12,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green.shade800,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Helper method to build detail chips
  Widget _buildDetailChip({
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build summary cards
  Widget _buildSummaryCard({
    required String title,
    required String value,
    required String unit,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: value,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  TextSpan(
                    text: ' $unit',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
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