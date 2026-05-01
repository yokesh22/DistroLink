import 'package:distro_link/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('DistroLinkApp renders setup placeholder', (tester) async {
    await tester.pumpWidget(const DistroLinkApp());
    expect(find.text('DistroLink — setup complete'), findsOneWidget);
  });
}
