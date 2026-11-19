
class CompraRoupa {
  final int? id;
  final double valorCompra;
  final int numeroVenda;
  final int sincronizado;

  CompraRoupa({
    this.id,
    required this.valorCompra,
    required this.numeroVenda,
    this.sincronizado = 1,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'valor_compra': valorCompra,
      'numero_venda': numeroVenda,
      'sincronizado': sincronizado,
    };
  }

  factory CompraRoupa.fromMap(Map<String, dynamic> map) {
    return CompraRoupa(
      id: map['id'] as int?,
      valorCompra: (map['valor_compra'] as num).toDouble(),
      numeroVenda: map['numero_venda'] as int,
      sincronizado: map['sincronizado'] as int? ?? 1,
    );
  }

  @override
  String toString() {
    return 'CompraRoupa{id: $id, valorCompra: $valorCompra, '
        'numeroVenda: $numeroVenda, sincronizado: $sincronizado}';
  }
}
