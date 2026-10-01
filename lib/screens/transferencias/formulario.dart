import 'package:flutter/material.dart';
import '../../components/editor.dart';
import '../../models/transferencia.dart';

class FormularioCompraRoupa extends StatefulWidget {
  @override
  State<FormularioCompraRoupa> createState() {
    return FormularioCompraRoupaState();
  }
}

class FormularioCompraRoupaState extends State<FormularioCompraRoupa> {
  final TextEditingController _controladorCampoNumeroVenda =
      TextEditingController();

  final TextEditingController _controladorCampoValorCompra =
      TextEditingController();

  static const _tituloAppBar = 'Nova compra de roupa';

  static const _rotuloCampoNumeroVenda = 'Número da venda';
  static const _dicaCampoNumeroVenda = '0000';

  static const _rotuloCampoValorCompra = 'Valor da compra';
  static const _dicaCampoValorCompra = '0,00';

  static const _textoBotaoConfirmar = 'Confirmar compra';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(_tituloAppBar),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Editor(
              controlador: _controladorCampoNumeroVenda,
              rotulo: _rotuloCampoNumeroVenda,
              dica: _dicaCampoNumeroVenda,
              icone: Icons.confirmation_number,
            ),

            Editor(
              controlador: _controladorCampoValorCompra,
              rotulo: _rotuloCampoValorCompra,
              dica: _dicaCampoValorCompra,
              icone: Icons.attach_money,
            ),

            ElevatedButton(
              onPressed: () {
                _criaCompraRoupa(
                  context,
                  _controladorCampoNumeroVenda,
                  _controladorCampoValorCompra,
                );
              },
              child: const Text(_textoBotaoConfirmar),
            ),
          ],
        ),
      ),
    );
  }
}

void _criaCompraRoupa(
  BuildContext context,
  TextEditingController controladorCampoNumeroVenda,
  TextEditingController controladorCampoValorCompra,
) {
  final int? numeroVenda =
      int.tryParse(controladorCampoNumeroVenda.text);

  final String valorTexto =
      controladorCampoValorCompra.text.replaceAll(',', '.');

  final double? valorCompra = double.tryParse(valorTexto);

  if (numeroVenda != null && valorCompra != null) {
    final compraCriada = CompraRoupa(valorCompra, numeroVenda);

    debugPrint('$compraCriada');

    Navigator.pop(context, compraCriada);
  }
}