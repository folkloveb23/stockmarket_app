import 'package:flutter/material.dart';
import 'stock.dart';

class AddPage extends StatefulWidget {
  final Stock? initialStock;

  const AddPage({super.key, this.initialStock});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _buyPriceController = TextEditingController();
  final _currentPriceController = TextEditingController();
  final _dateController = TextEditingController();
  String _category = 'เทคโนโลยี';
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();

    if (widget.initialStock != null) {
      _nameController.text = widget.initialStock!.name;
      _quantityController.text = widget.initialStock!.quantity.toString();
      _buyPriceController.text = widget.initialStock!.buyPrice.toString();
      _currentPriceController.text = widget.initialStock!.currentPrice.toString();
      _category = widget.initialStock!.category;
      _selectedDate = widget.initialStock!.purchaseDate;
      _dateController.text = "${_selectedDate!.toLocal()}".split(' ')[0];
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = "${_selectedDate!.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialStock == null ? "เพิ่มหุ้นใหม่" : "แก้ไขข้อมูลหุ้น"),
        backgroundColor: Colors.teal.shade700,
        elevation: 4.0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.initialStock == null ? "กรอกข้อมูลหุ้น" : "แก้ไขข้อมูลหุ้น",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade900,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'ชื่อหุ้น',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'โปรดระบุชื่อหุ้น';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'จำนวนหุ้น',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'โปรดระบุจำนวนหุ้น';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _buyPriceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'ราคาซื้อ (บาท)',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'โปรดระบุราคาซื้อ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _currentPriceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'ราคาปัจจุบัน (บาท)',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'โปรดระบุราคาปัจจุบัน';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    labelText: 'วันที่ซื้อ',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onTap: () => _selectDate(context),
                  readOnly: true,
                  validator: (value) {
                    if (_selectedDate == null) {
                      return 'โปรดเลือกวันที่';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _category,
                  items: ['เทคโนโลยี', 'การเงิน', 'สุขภาพ', 'อื่นๆ']
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _category = value!;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'หมวดหมู่',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'โปรดเลือกหมวดหมู่';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (_selectedDate == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('โปรดเลือกวันที่')),
                          );
                          return;
                        }

                        final updatedStock = Stock(
                          name: _nameController.text,
                          quantity: int.parse(_quantityController.text),
                          buyPrice: double.parse(_buyPriceController.text),
                          currentPrice: double.parse(_currentPriceController.text),
                          category: _category,
                          purchaseDate: _selectedDate!,
                        );

                        Navigator.pop(context, updatedStock);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.teal,
                      textStyle: const TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: const Text('บันทึกข้อมูล'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
