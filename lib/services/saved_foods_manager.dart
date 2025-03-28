class SavedFoodsManager {
  // Singleton pattern
  static final SavedFoodsManager _instance = SavedFoodsManager._internal();
  factory SavedFoodsManager() => _instance;
  SavedFoodsManager._internal();

  // List to store saved foods
  final List<Map<String, dynamic>> _savedFoods = [];

  // Getter for saved foods
  List<Map<String, dynamic>> get savedFoods => List.unmodifiable(_savedFoods);

  // Add a food item
  void addSavedFood(Map<String, dynamic> foodItem) {
    // Prevent duplicates
    if (!_savedFoods.any((food) => food['name'] == foodItem['name'])) {
      _savedFoods.add(foodItem);
    }
  }

  // Remove a specific food item
  void removeSavedFood(Map<String, dynamic> foodItem) {
    _savedFoods.removeWhere((food) => food['name'] == foodItem['name']);
  }

  // Clear all saved foods
  void clearSavedFoods() {
    _savedFoods.clear();
  }
}