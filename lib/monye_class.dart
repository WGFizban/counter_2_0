class MoneyData {
  List<Map<String, dynamic>> moneyValues = [
    {'value': 500, 'quantity': 0},
    {'value': 200, 'quantity': 0},
    {'value': 100, 'quantity': 0},
    {'value': 50, 'quantity': 0},
    {'value': 20, 'quantity': 0},
    {'value': 10, 'quantity': 0},
    {'value': 5, 'quantity': 0},
    {'value': 2, 'quantity': 0},
    {'value': 1, 'quantity': 0},
    {'value': 0.50, 'quantity': 0},
    {'value': 0.20, 'quantity': 0},
    {'value': 0.10, 'quantity': 0},
    {'value': 0.05, 'quantity': 0},
    {'value': 0.02, 'quantity': 0},
    {'value': 0.01, 'quantity': 0},
  ];

  void resetAllMoneyValue() {
    moneyValues = [
      {'value': 500, 'quantity': 0},
      {'value': 200, 'quantity': 0},
      {'value': 100, 'quantity': 0},
      {'value': 50, 'quantity': 0},
      {'value': 20, 'quantity': 0},
      {'value': 10, 'quantity': 0},
      {'value': 5, 'quantity': 0},
      {'value': 2, 'quantity': 0},
      {'value': 1, 'quantity': 0},
      {'value': 0.50, 'quantity': 0},
      {'value': 0.20, 'quantity': 0},
      {'value': 0.10, 'quantity': 0},
      {'value': 0.05, 'quantity': 0},
      {'value': 0.02, 'quantity': 0},
      {'value': 0.01, 'quantity': 0},
    ];
  }

  double get totalSum {
    return moneyValues.fold(
        0.0, (sum, item) => sum + item['value'] * item['quantity']);
  }

  void updateQuantity(int number, int? index) {
    if (index != null) {
      int currentQuantity = moneyValues[index]['quantity'];
      int newQuantity = currentQuantity * 10 + number;
      moneyValues[index]['quantity'] = newQuantity;
    }
  }

  void removeLastDigit(int? index) {
    if (index != null) {
      int currentQuantity = moneyValues[index]['quantity'];
      moneyValues[index]['quantity'] = (currentQuantity / 10).floor();
    }
  }
}
