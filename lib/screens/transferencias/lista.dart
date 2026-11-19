
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/transferencia.dart';
import '../../repositories/compra_repository.dart';
import 'formulario.dart';

class ListaComprasRoupa extends StatefulWidget {
  const ListaComprasRoupa({super.key});

  @override
  State<ListaComprasRoupa> createState() => ListaComprasRoupaState();
}

class ListaComprasRoupaState extends State<ListaComprasRoupa> {
  static const _tituloAppBar = 'Loja de Roupas';

  final CompraRepository _repository = CompraRepository();

  List<CompraRoupa> _compras = [];
  bool _carregando = true;
  bool _sincronizando = false;

  @override
  void initState() {
    super.initState();
    _carregarCompras();
  }

  // Busca as compras salvas no SQLite.
  Future<void> _carregarCompras() async {
    final compras = await _repository.listarCompras();

    if (!mounted) return;

    setState(() {
      _compras = compras;
      _carregando = false;
    });
  }

  // Atualiza a lista após o cadastro.
  Future<void> _atualiza(CompraRoupa? compraRecebida) async {
    if (compraRecebida == null) return;

    await _carregarCompras();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          compraRecebida.sincronizado == 1
              ? 'Compra cadastrada e sincronizada!'
              : 'Compra salva localmente. Aguardando sincronização.',
        ),
      ),
    );
  }

  // Sincroniza as compras pendentes com a API.
  Future<void> _sincronizar() async {
    setState(() {
      _sincronizando = true;
    });

    try {
      final quantidade =
          await _repository.sincronizarCompras();

      await _carregarCompras();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            quantidade > 0
                ? '$quantidade compra(s) sincronizada(s)!'
                : 'Nenhuma compra pendente para sincronizar.',
          ),
        ),
      );
    } catch (erro) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao sincronizar: $erro'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _sincronizando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(_tituloAppBar),
        actions: [
          IconButton(
            onPressed: _sincronizando ? null : _sincronizar,
            tooltip: 'Sincronizar compras',
            icon: _sincronizando
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.sync),
          ),
        ],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _compras.isEmpty
              ? const Center(
                  child: Text('Nenhuma compra cadastrada.'),
                )
              : ListView.builder(
                  itemCount: _compras.length,
                  itemBuilder: (context, indice) {
                    final compra = _compras[indice];

                    return ItemCompraRoupa(compra: compra);
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FormularioCompraRoupa(),
            ),
          ).then((resultado) {
            if (resultado is CompraRoupa) {
              _atualiza(resultado);
            }
          });
        },
        child: const Icon(Icons.checkroom),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat,
    );
  }
}

class ItemCompraRoupa extends StatelessWidget {
  final CompraRoupa compra;

  const ItemCompraRoupa({
    super.key,
    required this.compra,
  });

  @override
  Widget build(BuildContext context) {
    final formato = NumberFormat.simpleCurrency(locale: 'pt_BR');

    return Card(
      child: ListTile(
        leading: const Icon(Icons.checkroom),
        title: Text('Venda #${compra.numeroVenda}'),
        subtitle: Text(
          'Valor da compra: ${formato.format(compra.valorCompra)}',
        ),
        trailing: Icon(
          compra.sincronizado == 1
              ? Icons.cloud_done
              : Icons.cloud_off,
          color: compra.sincronizado == 1
              ? Colors.green
              : Colors.orange,
        ),
      ),
    );
  }
}
