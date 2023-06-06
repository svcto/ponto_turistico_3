import 'package:flutter/material.dart';
import 'package:ponto_turistico_3/pages/filtros_page.dart';
import 'package:ponto_turistico_3/pages/lista_page.dart';

void main() {
  runApp(const AppPontosTuristicos());
}

class AppPontosTuristicos extends StatelessWidget {
  const AppPontosTuristicos({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciador de Pontos Turísticos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.grey,
      ),
      home: ListaTurismoPage(),
      routes: {
        FiltrosPage.routeName: (BuildContext context) => FiltrosPage(),
      },
    );
  }
}