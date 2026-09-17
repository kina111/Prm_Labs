import 'dart:async';

import 'package:lab3_v2/Product.dart';

class ProductRepository {
  List<Product> _products = [
    Product(1, "iPhone 12", 999.99),
    Product(2, "Samsung Galaxy S21", 899.99),
  ];

  final StreamController<Product> controller = StreamController<Product>.broadcast();

  Future<List<Product>> getAll() async {
    await Future.delayed(Duration(seconds: 2));
    return _products;
  }

  Stream<Product> liveAdded(){
    return controller.stream;
  }

  void addProduct(Product newProduct){
    _products.add(newProduct);
    controller.sink.add(newProduct);
  }

  void dispose(){
    controller.close();
  }
}