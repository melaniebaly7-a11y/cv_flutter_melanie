import 'package:flutter_test/flutter_test.dart';
import 'package:cv_flutter_melanie/main.dart';

void main() {
  testWidgets('Affiche l ecran de connexion', (WidgetTester tester) async {
    await tester.pumpWidget(const CvMelanieApp());
    expect(find.text('Se connecter'), findsOneWidget);
  });
}
