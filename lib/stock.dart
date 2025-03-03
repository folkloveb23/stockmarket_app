class Stock {
  String name;
  int quantity;
  double buyPrice;
  double currentPrice;
  String category;
  DateTime purchaseDate; 

  Stock({
    required this.name,
    required this.quantity,
    required this.buyPrice,
    required this.currentPrice,
    required this.category,
    required this.purchaseDate, 
  });

  double get profitLoss => (currentPrice - buyPrice) * quantity;

  double get profitLossPercentage => ((currentPrice - buyPrice) / buyPrice) * 100;
}
