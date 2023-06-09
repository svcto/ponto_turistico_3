import 'dart:convert';
import 'package:http/http.dart';

import '../model/cep.dart';

class CepService  {
  static const baseUrl = 'https://viacep.com.br/ws/:cep/json/';

  Future<Map<String, dynamic>> findCep(String cep) async {

    final url = baseUrl.replaceAll(':cep', cep);
    final uri = Uri.parse(url);
    final Response response = await get(uri);
    if(response.statusCode != 200 || response.body.isEmpty){
      throw Exception();
    }

    final decodeBody = json.decode(response.body);
    return Map<String, dynamic>.from(decodeBody);


  }

  Future<Endereco> findCepAsObject(String cep) async {
    final map = await findCep(cep);
    return Endereco.fromJson(map);

  }
}