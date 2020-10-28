import 'package:http/http.dart' as http;
import 'dart:convert'; //* converte os dados em json
import 'dart:io';

void main() {
  menu();
}

//* menu
void menu() {
  print('\n selecione uma das opções abaixo:');
  print('\n 1 - Ver a cotação de hoje');

  String option = stdin.readLineSync();

  switch (int.parse(option)) {
    case 1:
      today();
      break;
    default:
      print('Selecione uma opção valida\n\n');
      menu();
      break;
  }
}

//* metodo today que pega a cotação de hoje
today() async {
  var data = await getData();
  print('----------------- HG - BRASIL COTAÇÂO -------------');
  print('${data['date']} -----> ${data['data']}');
}

Future getData() async {
  String url = 'http://api.hgbrasil.com/finance?key=fbf23385';
  http.Response response = await http.get(url);

  if (response.statusCode == 200) {
    //* decodificar o json e fazer virar um map
    var data = json.decode(response.body)['results']['currencies'];
    print(data);
    var usd = data['USD'];
    var eur = data['EUR'];
    var gbp = data['GBP'];
    var ars = data['ARS'];
    var btc = data['BTC'];

    Map formatedMap = Map();
  }
}
