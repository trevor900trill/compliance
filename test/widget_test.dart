
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/auth/repository/auth_repository.dart';
import 'package:myapp/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  testWidgets('Login page UI test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    SharedPreferences.setMockInitialValues({});
    final sharedPreferences = await SharedPreferences.getInstance();
    await tester.pumpWidget(MyApp(
      sharedPreferences: sharedPreferences,
      authRepository: MockAuthRepository(),
    ));

    // Verify that the login page is displayed.
    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Staff ID'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('LOGIN'), findsOneWidget);
  });
}
