import 'package:lab2/Car.dart';

class ElectricCar extends Car{

  // goi constructor cua cha de khoi tao 'brand
  ElectricCar(String brand) : super(brand);

  @override
  void drive(String from, String to){
    print('Electric car is driving from $from to $to');
  }
}