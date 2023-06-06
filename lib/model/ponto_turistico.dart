import 'package:intl/intl.dart';

class PontoTuristico {

  static const nomeTabela = 'ponto_turistico';
  static const campoId = 'id';
  static const campoNome = 'nome';
  static const campoDescricao = 'descricao';
  static const campoData = 'data';
  static const campoDiferenciais = 'diferenciais';
  static const campoLongitude = 'longitude';
  static const campoLatitude = 'latitude';

  int? id;
  String nome;
  String descricaoo;
  String diferenciais;
  DateTime? dataCadastro = DateTime.now();
  String longitude;
  String latitude;

  PontoTuristico({
    required this.id,
    required this.nome,
    required this.descricaoo,
    required this.diferenciais,
    required this.latitude,
    required this.longitude,
    this.dataCadastro});

  String get dataCadastroFormatado{
    if (dataCadastro == null){
      return '';
    }
    DateTime dt = dataCadastro!;
    String formattedDate = DateFormat('dd/MM/yyyy').format(dt);
    return formattedDate;
  }

  Map<String, dynamic> toMap() => {
    campoId: id == 0 ? null: id,
    campoNome: nome,
    campoDescricao: descricaoo,
    campoDiferenciais: diferenciais,
    campoData:
    dataCadastro == null ? null : DateFormat("yyyy-MM-dd").format(dataCadastro!),
    campoLatitude: latitude,
    campoLongitude: longitude
  };

  factory PontoTuristico.fromMap(Map<String, dynamic> map) => PontoTuristico(
    id: map[campoId] is int ? map[campoId] : null,
    descricaoo: map[campoDescricao] is String ? map[campoDescricao] : '',
    diferenciais: map[campoDiferenciais] is String ? map[campoDiferenciais] : '',
    latitude: map[campoLatitude] is String ? map[campoLatitude] : '',
    longitude: map[campoLongitude] is String ? map[campoLongitude] : '',
    nome: map[campoNome] is String ? map[campoNome] : '',
    dataCadastro: map[campoData] is String
        ? DateFormat("yyyy-MM-dd").parse(map[campoData])
        : null
  );


}