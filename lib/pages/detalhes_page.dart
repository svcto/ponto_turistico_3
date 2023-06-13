import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:ponto_turistico_3/pages/mapa_page.dart';

import '../model/ponto_turistico.dart';

class DetalhesPage extends StatefulWidget {
  final PontoTuristico pontoTuristico;

  const DetalhesPage({Key? key, required this.pontoTuristico}) : super(key: key);

  @override
  _DetalhesPageState createState() => _DetalhesPageState();
}

class _DetalhesPageState extends State<DetalhesPage> {

  Position? _localizacaoAtual;
  var _distancia;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes'),
      ),
      body: _criarBody(),
    );
  }

  Widget _criarBody() => Padding(
    padding: EdgeInsets.all(10),
    child: Column(
      children: [
        Row(
          children: [
            const Campo(descricao: 'Código: '),
            Valor(valor: '${widget.pontoTuristico.id}'),
          ],
        ),
        Row(
          children: [
            const Campo(descricao: 'Descrição: '),
            Valor(valor: widget.pontoTuristico.descricaoo),
          ],
        ),
        Row(
          children: [
            const Campo(descricao: 'Data: '),
            Valor(valor: widget.pontoTuristico.dataCadastroFormatado),
          ],
        ),
        Row(
          children: [
            const Campo(descricao: 'Nome: '),
            Valor(valor: widget.pontoTuristico.nome),
          ],
        ),
        Row(
          children: [
            const Campo(descricao: 'Diferenciais: '),
            Valor(valor: widget.pontoTuristico.diferenciais),
          ],
        ),
        Row(
          children: [
            const Campo(descricao: 'Cep: '),
            Valor(valor: widget.pontoTuristico.cep),
          ],
        ),
        Row(
          children: [
            const Campo(descricao: 'Localização: '),
            Valor(
              valor: 'Latitude: ${widget.pontoTuristico.latitude}  \n'
                  'Longitude: ${widget.pontoTuristico.longitude}',
            ),
            ElevatedButton(
                onPressed: _abrirCoordenadasNoMapaExterno,
                child: Icon(Icons.map)
            ),
            ElevatedButton(
                onPressed: _abrirCoordenadasMapaInterno,
                child: Text("Mapa interno")
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(
                Icons.route,
                color: Colors.white,
                size: 20,
              ),
              label: const Text('Calculo da distância'),
              onPressed: _calcularDistancia,
            )
          ],
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(8), // Define um raio de borda para deixar os cantos arredondados
          ),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              ' ${_localizacaoAtual == null ? "--" : _distancia}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )

      ],
    ),
  );

  void _abrirCoordenadasNoMapaExterno() {
    if (widget.pontoTuristico.latitude.isEmpty || widget.pontoTuristico.longitude.isEmpty ) {
      return;
    }
    MapsLauncher.launchCoordinates(double.parse(widget.pontoTuristico.latitude), double.parse(widget.pontoTuristico.longitude));
  }

  void _abrirCoordenadasMapaInterno(){
    if(widget.pontoTuristico.longitude == '' || widget.pontoTuristico.latitude == ''){
      return;
    }
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => MapaPage(
            latitude: double.parse(widget.pontoTuristico.latitude),
            longitude: double.parse(widget.pontoTuristico.longitude)))
    );
  }



  void _calcularDistancia(){
    _obterLocalizacaoAtual();

  }


  void _obterLocalizacaoAtual() async{
    bool servicoHabilitado = await _servicoHabilitado();
    if(!servicoHabilitado){
      return;
    }
    bool permissoesPermitidas = await _verificaPermissoes();
    if(!permissoesPermitidas){
      return;
    }
    Position posicao = await Geolocator.getCurrentPosition();
    setState(() {
      _localizacaoAtual = posicao;
      _distancia = Geolocator.distanceBetween(
          posicao.latitude,
          posicao.longitude,
          double.parse(widget.pontoTuristico.latitude),
          double.parse(widget.pontoTuristico.longitude));
      if(_distancia > 1000){
        var _distanciaKM = _distancia/1000;
        _distancia = "${double.parse((_distanciaKM).toStringAsFixed(2))}KM";
      }else{
        _distancia = "${_distancia.toStringAsFixed(2)}M";
      }
    });
  }

  Future<bool> _servicoHabilitado() async {
    bool servicoHabilitado = await Geolocator.isLocationServiceEnabled();
    if (!servicoHabilitado) {
      await _mostrarMensagemDialog(
          'Para utilizar este recurso, é '
              ' necessário acessar as configurações '
              ' para permitir a utilização do serviço de localização.'
      );
      Geolocator.openAppSettings();
      return false;
    }
    return true;
  }


  Future<bool> _verificaPermissoes() async {
    LocationPermission permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
      if (permissao == LocationPermission.denied) {
        await _mostrarMensagemDialog('Falta de permissão');
        return false;
      }
    }
    if (permissao == LocationPermission.deniedForever) {
      await _mostrarMensagemDialog(
          'Para utilizar este recurso,'
              ' é necessário acessar as configurações'
              ' para permitir a utilização do serviço de localização!!'
      );
      Geolocator.openAppSettings();
      return false;
    }
    return true;
  }


  void _mostrarMensagem(String mensagem){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(mensagem)
        )
    );
  }


  Future<void> _mostrarMensagemDialog(String mensagem) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Atenção'),
          content: Text(mensagem),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }


}






class Campo extends StatelessWidget {
  final String descricao;

  const Campo({Key? key, required this.descricao}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Text(
        descricao,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class Valor extends StatelessWidget {
  final String valor;

  const Valor({Key? key, required this.valor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: Text(valor),
    );
  }
}
