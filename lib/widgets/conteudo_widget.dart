import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maps_launcher/maps_launcher.dart';

import '../model/ponto_turistico.dart';
import '../pages/mapa_page.dart';

class ConteudoWidget extends StatefulWidget{
  final PontoTuristico? turismoAtual;

  ConteudoWidget({Key? key, this.turismoAtual}) : super (key: key);


  @override
  ConteudoWidgetState createState() => ConteudoWidgetState();

}
class ConteudoWidgetState extends State<ConteudoWidget> {

  Position? _localizacaoAtual;
  final _controller = TextEditingController();

  String get _latitude => _localizacaoAtual?.latitude.toString() ?? '';

  String get _longitude => _localizacaoAtual?.longitude.toString() ?? '';

  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _descricaooController = TextEditingController();
  final _diferenciaisController = TextEditingController();
  final _dataController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _latitudeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.turismoAtual != null) {
      _nomeController.text = widget.turismoAtual!.nome;
      _diferenciaisController.text = widget.turismoAtual!.diferenciais;
      _descricaooController.text = widget.turismoAtual!.descricaoo;
      _dataController.text = widget.turismoAtual!.dataCadastroFormatado;
      _longitudeController.text = widget.turismoAtual!.longitude;
      _latitudeController.text = widget.turismoAtual!.latitude;

      // horaControllerController.text =formattedDate;

    }
  }


  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: 'Nome'),
              validator: (String? valor) {
                if (valor == null || valor.isEmpty) {
                  return 'Informe o Nome';
                }
                return null;
              },

            ),
            TextFormField(
              controller: _descricaooController,
              decoration: InputDecoration(labelText: 'Descrição'),
              validator: (String? valor) {
                if (valor == null || valor.isEmpty) {
                  return 'Informe a descrição';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _diferenciaisController,
              decoration: InputDecoration(labelText: 'Diferenciais'),
              validator: (String? valor) {
                if (valor == null || valor.isEmpty) {
                  return 'Informe os Diferenciais';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: _obterLocalizacaoAtual,
              child: Text('Obter Localização'),
            ),
            Text('Latitude: ${widget.turismoAtual?.latitude ??
                _latitude}  |  Longitude: ${widget.turismoAtual?.longitude ??
                _longitude}'
            ),

            ElevatedButton(
                onPressed: _abrirCoordenadasNoMapaExterno,
                child: Icon(Icons.map)
            ),
            // ElevatedButton(
            //     onPressed: _abrirCoordenadasNoMapaInterno,
            //     child: Icon(Icons.map)
            // ),
          ],
        )
        )
    );
  }

  bool dadosValidos() => _formKey.currentState?.validate() == true;

  PontoTuristico get novoTurismo =>
      PontoTuristico(
          id: widget.turismoAtual?.id ?? 0,
          nome: _nomeController.text,
          descricaoo: _descricaooController.text,
          diferenciais: _diferenciaisController.text,
          latitude: _latitude,
          longitude: _longitude,
          dataCadastro: DateTime.now()
      );


  Future<bool> _permissoesOk() async {
    LocationPermission permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
      if (permissao == LocationPermission.denied) {
        _mostrarMensagem(
            'Não será possível utilizar o '
                'recurso por falta de permissão');
        return false;
      }
    }
    if (permissao == LocationPermission.deniedForever) {
      await _mostrarMensagemDialog(
          'Para utilizar esse recurso,'
              ' você deverá acessar as configurações '
              ' do app e permitir a utilização'
              ' do serviço de localização!!');
      Geolocator.openAppSettings();
      return false;
    }
    return true;
  }

  void _obterLocalizacaoAtual() async {
    bool servicoHabilitado = await _servicoHabilitado();
    if (!servicoHabilitado) {
      return;
    }
    bool permissoesOk = await _permissoesOk();
    if (!permissoesOk) {
      return;
    }
    _localizacaoAtual = await Geolocator.getCurrentPosition();
    setState(() {

    });
  }

  Future<bool> _servicoHabilitado() async {
    bool servicoHabilotado = await Geolocator.isLocationServiceEnabled();
    if (!servicoHabilotado) {
      await _mostrarMensagemDialog(
          'Para utilizar esse recurso, você deverá '
              'habilitar o serviço de localização '
              'no dispositivo');
      Geolocator.openLocationSettings();
      return false;
    }
    return true;
  }

  void _mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensagem)));
  }

  Future<void> _mostrarMensagemDialog(String mensagem) async {
    await showDialog(
      context: context,
      builder: (_) =>
          AlertDialog(
            title: Text('Atenção'),
            content: Text(mensagem),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
    );
  }

  void _abrirCoordenadasNoMapaExterno() {
    if (_longitude.isEmpty || _latitude.isEmpty) {
      return;
    }
    MapsLauncher.launchCoordinates(
        double.parse(_latitude), double.parse(_longitude));
  }

}