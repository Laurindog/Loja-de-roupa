
import 'package:flutter_test/flutter_test.dart';
import 'package:bank/main.dart';

void main() {
  testWidgets('Aplicativo Loja de Roupas inicia',
      (WidgetTester tester) async {
    await tester.pumpWidget(const LojaDeRoupasApp());

    expect(find.text('Loja de Roupas'), findsOneWidget);
  });
}
