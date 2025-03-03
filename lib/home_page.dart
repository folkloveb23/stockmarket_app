import 'package:flutter/material.dart';
import 'add_page.dart';
import 'stock.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Stock> stocks = [];

  void _navigateToAddPage([Stock? stockToEdit]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPage(initialStock: stockToEdit),
      ),
    );

    if (result != null) {
      setState(() {
        if (stockToEdit == null) {
          stocks.add(result);
        } else {
          final index = stocks.indexOf(stockToEdit);
          stocks[index] = result;
        }
      });
    }
  }

  void _deleteStock(int index) {
    final deletedStock = stocks[index];
    setState(() {
      stocks.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("ลบ ${deletedStock.name} แล้ว"),
        action: SnackBarAction(
          label: "ยกเลิก",
          onPressed: () {
            setState(() {
              stocks.insert(index, deletedStock);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.teal.shade700,
        title: Text(widget.title, style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 4.0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: stocks.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.insert_chart, size: 80, color: Colors.grey.shade400),
                    const SizedBox(height: 10),
                    Text(
                      'ยังไม่มีหุ้นที่บันทึก',
                      style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: stocks.length,
                itemBuilder: (context, index) {
                  final stock = stocks[index];
                  final isProfit = stock.profitLoss >= 0;
                  final stockValue = stock.quantity * stock.currentPrice; 

                  return Dismissible(
                    key: Key(stock.name),
                    direction: DismissDirection.startToEnd,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.delete, color: Colors.white, size: 30),
                    ),
                    onDismissed: (direction) => _deleteStock(index),
                    child: Card(
                      elevation: 5.0,
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              stock.name,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${stock.profitLossPercentage.toStringAsFixed(1)}%",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: isProfit ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("จำนวน: ${stock.quantity} หุ้น"),
                            Text(
                              "กำไร/ขาดทุน: ${isProfit ? '+' : ''}฿${stock.profitLoss.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isProfit ? Colors.green : Colors.red,
                              ),
                            ),
                            Text(
                              "มูลค่ารวม: ฿${stockValue.toStringAsFixed(2)}", // 
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isProfit ? Icons.trending_up : Icons.trending_down,
                              color: isProfit ? Colors.green : Colors.red,
                            ),
                            Text(
                              "฿${stock.currentPrice.toStringAsFixed(2)}",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        onTap: () => _navigateToAddPage(stock),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddPage(),
        backgroundColor: Colors.teal.shade700,
        label: const Text('เพิ่มหุ้น'),
        icon: const Icon(Icons.add),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
