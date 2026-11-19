
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/transferencia.dart';

class ApiService {
  static const String baseUrl = 'https://loja-roupas-api.onrender.com';

  // Cadastrar uma compra na API.
  Future<CompraRoupa> cadastrarCompra(CompraRoupa compra) async {
    final resposta = await http.post(
      Uri.parse('$baseUrl/compras'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'numero_venda': compra.numeroVenda,
        'valor_compra': compra.valorCompra,
      }),
    );

    if (resposta.statusCode == 200 || resposta.statusCode == 201) {
      final dados = jsonDecode(resposta.body);

      return CompraRoupa(
        id: dados['id'],
        numeroVenda: dados['numero_venda'],
        valorCompra: double.parse(
          dados['valor_compra'].toString(),
        ),
        sincronizado: 1,
      );
    }

    throw Exception(
      'Erro ${resposta.statusCode}: ${resposta.body}',
    );
  }

  // Buscar compras cadastradas na API.
  Future<List<CompraRoupa>> listarCompras() async {
    final resposta = await http.get(
      Uri.parse('$baseUrl/compras'),
    );

    if (resposta.statusCode == 200) {
      final List dados = jsonDecode(resposta.body);

      return dados.map((item) {
        return CompraRoupa(
          id: item['id'],
          numeroVenda: item['numero_venda'],
          valorCompra: double.parse(
            item['valor_compra'].toString(),
          ),
          sincronizado: 1,
        );
      }).toList();
    }

    throw Exception(
      'Erro ${resposta.statusCode}: ${resposta.body}',
    );
  }
}
