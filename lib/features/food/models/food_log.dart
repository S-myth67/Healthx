class FoodLog {
  final String id;
  final DateTime eatenAt;
  final String mealType; // Breakfast, Lunch, Dinner, Snack

  FoodLog({
    required this.id,
    required this.eatenAt,
    required this.mealType,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eatenAt': eatenAt.toIso8601String(),
      'mealType': mealType,
    };
  }

  factory FoodLog.fromJson(Map<String, dynamic> json) {
    return FoodLog(
      id: json['id'],
      eatenAt: DateTime.parse(json['eatenAt']),
      mealType: json['mealType'],
    );
  }
}
