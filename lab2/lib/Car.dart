class Car {
  String brand;

  Car (this.brand);

  Car.unknown() : brand = 'Unknown';

  void drive(String from, String to){
    print('Driving from $from to $to');
  }
}