import 'package:http/http.dart' as http;
import 'dart:convert'; //* converte os dados em json
import 'dart:io';

void main() {
  menu();
}

void menu() {
  print('################### Extrator de Dados em Dart #################');
  print('\n selecione uma das opções abaixo:');
  print('\n 1 - Ver a cotação de hoje');
  print('\n 2 - Registrar a cotação de hoje');
  print('\n 3 - Ver cotações registradas');

  var option = stdin.readLineSync();

  switch (int.parse(option)) {
    case 1:
      today();
      break;
    case 2:
      registerData();
      break;
    case 3:
      listData();
      break;
    default:
      print('Selecione uma opção valida\n\n');
      menu();
      break;
  }
}

//* metodo today pega a cotação de hoje
void today() async {
  var data = await getData();
  print('----------------- HG - BRASIL COTAÇÂO -------------');
  print('${data['date']} -----> ${data['data']}');
}

void registerData() async {
  var hgData = await getData();
  dynamic fileData = readFile();
  Directory dir = Directory.current;

  fileData = (fileData != null && fileData.length > 0
      ? json.decode(fileData)
      : List());

  String now() {
    var now = DateTime.now();
    return '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year.toString().padLeft(2, '0')}';
  }

  var exists = false;
  fileData.foreach((data) {
    if (data['date'] == now()) exists = true;
  });

  if (!exists) {
    fileData.add({"date": now(), "data": "${hgData['data']}"});
    File file = File(dir.path + '/meu_arquivo.txt');
    RandomAccessFile raf = file.openSync(mode: FileMode.write);

    raf.writeStringSync(json.encode(fileData).toString());
    raf.flushSync();
    raf.closeSync();

    print(
        '\n\n*-*-*-*-*-*-*-*-*-*-Dados salvos com sucesso*-*-*-*-*-*-*-*-*-*-*-*-*-');
  } else {
    print(
        '\n\n *-*-*-*-*-*-*-*-* Registro não adicionado, ja existe um log financeiro de hoje cadastrado');
  }
}

void listData() {
  dynamic fileData = readFile();
  fileData = (fileData != null && fileData.length > 0
      ? json.decode(fileData)
      : List());
  print('\n\n *-*-*-*-*-*-*-*-* Listagem de dados *-*-*-*-*-*-*-*-*-**-');

  fileData.foreach((data) {
    print('${data['date']} -> ${data['data']}');
  });
}

String readFile() {
  Directory dir = Directory.current;
  File file = File(dir.path + '/meu_arquivo.txt');
  if (!file.existsSync()) {
    print('Arquivo não encontrado');
    return null;
  }
  return file.readAsStringSync();
}

Future getData() async {
  //* solicitamos a requisição via http
  String url = 'http://api.hgbrasil.com/finance?key=fbf23385';
  http.Response response = await http.get(url);

  String now() {
    var now = DateTime.now();
    return '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year.toString().padLeft(2, '0')}';
  }

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
    formatedMap['date'] = now();
    formatedMap['data'] =
        '${usd['name']}: ${usd['buy']} | ${eur['name']}: ${eur['buy']} | ${gbp['name']}: ${gbp['buy']} |${ars['name']}: ${ars['buy']} |${btc['name']}: ${btc['buy']} |';

    return formatedMap;
  } else {
    throw ('Falhou');
  }
}
