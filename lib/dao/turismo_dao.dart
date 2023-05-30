import '../db/database_provider.dart';
import '../model/ponto_turistico.dart';

class TurismoDao {
  final databaseProvider = DatabaseProvider.instance;

  Future<bool> salvar(PontoTuristico pontoturistico) async {
    final database = await databaseProvider.database;
    final valores = pontoturistico.toMap();
    if (pontoturistico.id == 0) {
      pontoturistico.id = await database.insert(PontoTuristico.nomeTabela, valores);
      return true;
    } else {
      final registrosAtualizados = await database.update(
        PontoTuristico.nomeTabela,
        valores,
        where: '${PontoTuristico.campoId} = ?',
        whereArgs: [pontoturistico.id],
      );
      return registrosAtualizados > 0;
    }
  }

  Future<List<PontoTuristico>> listar({
    String filtro = '',
    String campoOrdenacao = PontoTuristico.campoId,
    bool usarOrdemDecrescente = false,
  }) async {
    String? where;
    if (filtro.isNotEmpty) {
      where = "UPPER(${PontoTuristico.campoDescricao}) LIKE '${filtro.toUpperCase()}%'";
    }
    var orderBy = campoOrdenacao;
    if (usarOrdemDecrescente) {
      orderBy += ' DESC';
    }
    final database = await databaseProvider.database;
    final resultado = await database.query(
      PontoTuristico.nomeTabela,
      columns: [
        PontoTuristico.campoId,
        PontoTuristico.campoDescricao,
        PontoTuristico.campoDiferenciais,
        PontoTuristico.campoData,
        PontoTuristico.campoNome,
        PontoTuristico.campoLatitude,
        PontoTuristico.campoLongitude
      ],
      where: where,
      orderBy: orderBy,
    );
    return resultado.map((m) => PontoTuristico.fromMap(m)).toList();
  }



  Future<bool> remover(int id) async {
    final database = await databaseProvider.database;
    final registrosAtualizados = await database.delete(
      PontoTuristico.nomeTabela,
      where: '${PontoTuristico.campoId} = ?',
      whereArgs: [id],
    );
    return registrosAtualizados > 0;
  }


}