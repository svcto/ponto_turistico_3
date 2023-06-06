import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/ponto_turistico.dart';

class FiltrosPage extends StatefulWidget{
  static const routeName = '/filtro';
  static const chaveCampoOrdenacao = 'campoOrdenacao';
  static const chaveUsarOrdemDecrescente = 'usarOrdemDecrescente';
  static const chaveCampoDescricao = 'campoDescricao';
  static const chaveCampoDiferenciais = 'campoDiferencial';
  static const chaveCampoNome = 'campoNome';

  @override
  _FiltrosPageState createState() => _FiltrosPageState();

}
class _FiltrosPageState extends State<FiltrosPage> {

  final camposParaOrdenacao = {
    PontoTuristico.campoId: 'Código',
    PontoTuristico.campoNome: 'Nome',
    PontoTuristico.campoDescricao: 'Descrição',
    PontoTuristico.campoDiferenciais: 'Diferenciais',
    PontoTuristico.campoData: 'Data de cadastro'
  };

  late final SharedPreferences pref;


  final descricaoController = TextEditingController();
  final diferenciaisController = TextEditingController();
  final nomeController = TextEditingController();


  bool usarOrdemDecrescente = false;
  bool alterouValores = false;
  String campoOrdenacao = PontoTuristico.campoId;



  @override
  void initState(){
    super.initState();
    _carregaDadosSharedPreferences();
  }

  void _carregaDadosSharedPreferences() async {
    pref = await SharedPreferences.getInstance();
    setState(() {


      
      campoOrdenacao = pref.getString(FiltrosPage.chaveCampoOrdenacao) ?? PontoTuristico.campoId;
      usarOrdemDecrescente = pref.getBool(FiltrosPage.chaveUsarOrdemDecrescente) == true;
      descricaoController.text = pref.getString(FiltrosPage.chaveCampoDescricao) ?? '' ;
      descricaoController.text = pref.getString(FiltrosPage.chaveCampoDescricao) ?? '';
      diferenciaisController.text =
          pref.getString(FiltrosPage.chaveCampoDiferenciais) ?? '';
      nomeController.text =
          pref.getString(FiltrosPage.chaveCampoNome) ?? '';

    });
  }


  void _onCampoParaOrdenacaoChanged(String? valor){
    pref.setString(FiltrosPage.chaveCampoOrdenacao, valor!);
    alterouValores = true;
    setState(() {
      campoOrdenacao = valor;
    });
  }

  void _onUsarOrdemDecrescenteChanged(bool? valor){
    pref.setBool(FiltrosPage.chaveUsarOrdemDecrescente, valor!);
    alterouValores = true;
    setState(() {
      usarOrdemDecrescente = valor;
    });
  }

  void _onFiltrosDescricaoChanged(String? valor){
    pref.setString(FiltrosPage.chaveCampoDescricao, valor!);
    alterouValores = true;
  }

  void _onFiltrosDiferenciaisChanged(String? valor){
    pref.setString(FiltrosPage.chaveCampoDiferenciais, valor!);
    alterouValores = true;
  }

  void _onFiltrosNomeChanged(String? valor){
    pref.setString(FiltrosPage.chaveCampoNome, valor!);
    alterouValores = true;
  }

  Future<bool> _onVoltarClick() async {
    Navigator.of(context).pop(alterouValores);


    return true;
  }

  Widget _criarBody() {
    return ListView(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 10, top: 10),
          child: Text('Campos para ordenação'),
        ),
        for (final campo in camposParaOrdenacao.keys)
          Row(
            children: [
              Radio(
                value: campo,
                groupValue: campoOrdenacao,
                onChanged: _onCampoParaOrdenacaoChanged,
              ),
              Text(camposParaOrdenacao[campo]!),
            ],
          ),
        const Divider(),
        Row(
          children: [
            Checkbox(
              value: usarOrdemDecrescente,
              onChanged: _onUsarOrdemDecrescenteChanged,
            ),
            Text('Usar ordem decrescente'),
          ],
        ),
        Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'Informe a descricao de busca',
            ),
            controller: descricaoController ,
            onChanged: _onFiltrosDescricaoChanged,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'Informe os diferenciais da busca',
            ),
            controller: diferenciaisController,
            onChanged: _onFiltrosDiferenciaisChanged,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'Informe o nome de busca',
            ),
            controller: nomeController,
            onChanged: _onFiltrosNomeChanged,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context){
    return WillPopScope(
      onWillPop: _onVoltarClick,
      child: Scaffold(
        appBar: AppBar(title: const Text('Filtros e Ordenação'),
        ),
        body: _criarBody(),
      ),
    );
  }

}
