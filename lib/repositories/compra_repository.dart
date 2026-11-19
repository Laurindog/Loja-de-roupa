
import '../database/app_database.dart';
import '../models/transferencia.dart';
import '../services/api_service.dart';

class CompraRepository {
  final ApiService _apiService = ApiService();

  // Cadastra uma compra, tentando primeiro pela API.
  Future<CompraRoupa> cadastrarCompra(CompraRoupa compra) async {
    int sincronizado = 0;

    try {
      // Tenta enviar a compra para o servidor.
      await _apiService.cadastrarCompra(compra);

      sincronizado = 1;
    } catch (erro) {
      // Se a API estiver indisponível, mantém a compra pendente.
      sincronizado = 0;
    }

    // Salva a compra no SQLite.
    final compraLocal = CompraRoupa(
      numeroVenda: compra.numeroVenda,
      valorCompra: compra.valorCompra,
      sincronizado: sincronizado,
    );

    final id = await salvarCompraLocal(compraLocal);

    return CompraRoupa(
      id: id,
      numeroVenda: compra.numeroVenda,
      valorCompra: compra.valorCompra,
      sincronizado: sincronizado,
    );
  }

  // Busca as compras armazenadas no SQLite.
  Future<List<CompraRoupa>> listarCompras() async {
    return buscarComprasLocais();
  }

  // Envia as compras pendentes para a API.
  Future<int> sincronizarCompras() async {
    final pendentes = await buscarComprasPendentes();

    int quantidadeSincronizada = 0;

    for (final compra in pendentes) {
      try {
        await _apiService.cadastrarCompra(compra);

        if (compra.id != null) {
          await marcarCompraSincronizada(compra.id!);
          quantidadeSincronizada++;
        }
      } catch (erro) {
        // Se falhar, a compra continua pendente.
        continue;
      }
    }

    return quantidadeSincronizada;
  }
}
