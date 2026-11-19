
import 'package:flutter/material.dart';

import '../../components/editor.dart';
import '../../models/transferencia.dart';
import '../../repositories/compra_repository.dart';

class FormularioCompraRoupa extends StatefulWidget {
  const FormularioCompraRoupa({super.key});

  @override
  State<FormularioCompraRoupa> createState() {
    return FormularioCompraRoupaState();
  }
}

class FormularioCompraRoupaState
    extends State<FormularioCompraRoupa> {

  final TextEditingController _controladorCampoNumeroVenda =
      TextEditingController();

  final TextEditingController _controladorCampoValorCompra =
      TextEditingController();

  final CompraRepository _repository = CompraRepository();

  bool _carregando = false;

  static const _tituloAppBar = 'Nova compra de roupa';

  static const _rotuloCampoNumeroVenda = 'Número da venda';
  static const _dicaCampoNumeroVenda = '0000';

  static const _rotuloCampoValorCompra = 'Valor da compra';
  static const _dicaCampoValorCompra = '0,00';

  static const _textoBotaoConfirmar = 'Confirmar compra';

  @override
  void dispose() {
    _controladorCampoNumeroVenda.dispose();
    _controladorCampoValorCompra.dispose();
    super.dispose();
  }

  Future<void> _criarCompra() async {
    final int? numeroVenda =
        int.tryParse(_controladorCampoNumeroVenda.text);

    final String valorTexto =
        _controladorCampoValorCompra.text.replaceAll(',', '.');

    final double? valorCompra = double.tryParse(valorTexto);

    if (numeroVenda == null ||
        numeroVenda <= 0 ||
        valorCompra == null ||
        valorCompra <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Informe um número de venda e um valor válido.'),
        ),
      );
      return;
    }

    setState(() {
      _carregando = true;
    });

    try {
      final compra = CompraRoupa(
        valorCompra: valorCompra,
        numeroVenda: numeroVenda,
      );

      // O Repository tenta a API e, se falhar, utiliza o SQLite.
      final CompraRoupa compraSalva =
          await _repository.cadastrarCompra(compra);

      if (!mounted) return;

      Navigator.pop(context, compraSalva);
    } catch (erro) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar compra: $erro'),
        ),
      );

      setState(() {
        _carregando = false;
      });
    }
  }

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
              onPressed: _carregando ? null : _criarCompra,
              child: _carregando
                  ? const CircularProgressIndicator()
                  : const Text(_textoBotaoConfirmar),
            ),
          ],
        ),
      ),
    );
  }
}
