import 'package:flutter/material.dart';
import '../../models/transferencia.dart';
import 'formulario.dart';
import 'package:intl/intl.dart';

class ListaComprasRoupa extends StatefulWidget {
  final List<CompraRoupa> _compras = [
    CompraRoupa(89.90, 101),
    CompraRoupa(149.90, 102),
  ];

  @override
  State<ListaComprasRoupa> createState() {
    return ListaComprasRoupaState();
  }
}

class ListaComprasRoupaState extends State<ListaComprasRoupa> {
  static const _tituloAppBar = 'Loja de Roupas';

  void _atualiza(CompraRoupa? compraRecebida) {
    if (compraRecebida != null) {
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          widget._compras.add(compraRecebida);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(_tituloAppBar),
      ),

      body: ListView.builder(
        itemCount: widget._compras.length,
        itemBuilder: (context, indice) {
          final compra = widget._compras[indice];

          return ItemCompraRoupa(compra);
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return FormularioCompraRoupa();
              },
            ),
          ).then(
            (compraRecebida) => _atualiza(compraRecebida),
          );
        },
        child: const Icon(Icons.checkroom),
      ),

      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat,
    );
  }
}

class ItemCompraRoupa extends StatelessWidget {
  final CompraRoupa _compra;

  ItemCompraRoupa(this._compra);

  @override
  Widget build(BuildContext context) {
    final NumberFormat formato =
        NumberFormat.simpleCurrency(locale: 'pt_BR');

    return Card(
      child: ListTile(
        leading: const Icon(Icons.checkroom),
        title: Text(
          'Venda #${_compra.numeroVenda}',
        ),
        subtitle: Text(
          'Valor da compra: ${formato.format(_compra.valorCompra)}',
        ),
      ),
    );
  }
}