import 'package:flutter_test/flutter_test.dart';

import 'package:proyectoestacionamiento/Pages/main.dart';

void main() {
  testWidgets('muestra la pantalla inicial de inicio de sesión', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('SmartParking'), findsOneWidget);
    expect(find.text('Bienvenido'), findsOneWidget);
    expect(find.text('Iniciar sesión'), findsOneWidget);
  });
}
