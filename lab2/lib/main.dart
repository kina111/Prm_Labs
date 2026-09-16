import 'package:lab2/ElectricCar.dart';
import 'package:http/http.dart' as http;
// flutter pub add http
void main() {
  // // step 1
  // List<int> numbers = [10, 20, 30];
  //
  // // step 2
  // int a = 10, b = 20;
  // print('Sum of ($a + $b) = ${a+b} | Diff of ($a - $b) = ${a-b}');
  // print('is $a equal to $b? ${a == b}');
  // print('is $a greater than 9 and is $b greater than $a? ${a > 9 && b > a}');
  //
  // var result = (a + b > 20) ? "Sum is greater than 20" : "Sum is not greater than 20";
  // print(result);
  //
  // // step 3
  // Set<int> uniqueNumbers = {1, 2, 3, 4, 5};
  // Map<String, String> myInfo = {
  //   'name': 'Nam',
  //   'age': '21',
  //   'major': 'SE',
  //   'gender': 'male'
  // };
  //
  // // step 4
  // print('My name is: ${myInfo['name']}');
  // print('My age is: ${myInfo['age']}');
  //
  // myInfo['country'] = 'Vietnam';
  // myInfo.remove('gender');
  //
  // print('Map after adding and removing: $myInfo');


  // Exe 3:
  // step 1

  // double score = 9.5;
  // if (score == 10){
  //   print('Perfect score');
  // }else{
  //   print('Not perfect score');
  // }
  //
  // // step 2
  // String day = 'Wednesday';
  // switch(day){
  //   case 'Monday':
  //     print('Today is Monday');
  //     break;
  //   case 'Tuesday':
  //     print('Today is Tuesday');
  //     break;
  //   case 'Wednesday':
  //     print('Today is Wednesday');
  //     break;
  //   case 'Thursday':
  //     print('Today is Thursday');
  //     break;
  //   case 'Friday':
  //     print('Today is Friday');
  //     break;
  //   case 'Saturday':
  //     print('Today is Saturday');
  //     break;
  // }
  //
  // // step 3
  // List<int> numbers = [1, 2, 3, 4, 5];
  // for (int i = 0; i < numbers.length; i++){
  //   print(numbers[i]);
  // }
  // for (int i in numbers){
  //   print(i);
  // }
  //
  // numbers.forEach((i) {
  //   print(i);
  // });
  //
  // // step 4
  //
  // print(sum(10, 20));
  // print(sum2(10, 20));


  // Exe 4:
  // ElectricCar electricCar = new ElectricCar('Tesla');
  // electricCar.drive('HCM', 'HN');

  // // Exe 5:
  // //getPokemonInfo('pikachu');
  // User temp = User(name: 'Nam');
  //
  // // use ?. to call property safety
  // int? len = temp.email?.length;
  // print(len);
  //
  // // use ?? to get the right value if the left value is null
  // String email = temp.email ?? 'Unknown';
  // print(email);
  //
  // // use ! to assert that the value is not null\
  // temp.email = 'nam@yopmail.com';
  // int exactLength = temp.email!.length;
  // print(exactLength);


  // step 4
  print('Start stream ...');
  Stream<int> stream = numberStream(5);
  stream.listen(
      (int value) {
        print('Value: $value');
      },
      onError: (error) {
        print('Error: $error');
      },
      onDone: () {
        print('Stream done');
      }
  );
  print('Lệnh này chạy ngay lập tức, không bị block bởi Stream.\n');

}


Stream<int> numberStream(int maxCount) async* {
  for (int i = 1; i <= maxCount; i++){
    // wait for 1 second
    await Future.delayed(Duration(seconds: 1));

    // 'yield' giống như 'return', nhưng nó không kết thúc hàm.
    // Nó đẩy 1 giá trị vào Stream và tiếp tục chạy vòng lặp.
    yield i;
  }
}


int sum(int a, int b){
  return a + b;
}
int sum2(int a, int b) => a + b;

// create an async function
Future<void> getPokemonInfo(String pokeName) async {
  print('Start fetching: ...');
  try{
    final url = Uri.parse('https://pokeapi.co/api/v2/pokemon/$pokeName');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      print(response.body);
    }else{
      print('Error: ${response.statusCode}');
    }
  }catch(error){
    print("Connecting error: $error");
  }
}
class User {
  String name;
  String? email;

  User({required this.name, this.email});
}