class Product {
  int id;
  String name;
  double price;

  Product(this.id, this.name, this.price);

  @override
  String toString() {
    return 'Product(id: $id, name: $name, price: $price)';
  }
}