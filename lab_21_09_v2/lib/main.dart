import 'Employee.dart';
import 'Car.dart';

void main() {
  Car normalCar = Car("Toyota", 2020, false);
  normalCar.startEngine();

  Car electricCar = Car.tesla(2022);
  electricCar.startEngine();


  // List<Developer> teamA = [Developer("An"), Developer("Bình")];
  // List<Developer> teamB = [Developer("Cường")];
  // List<Developer> allStaff = [...teamA, ...teamB];
  //
  // for (Developer d in allStaff){
  //   d.checkIn();
  // }
}
