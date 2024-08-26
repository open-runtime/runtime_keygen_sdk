import 'package:dotenv/dotenv.dart';
import 'package:keygen/keygen.dart';
import 'package:openapi/api.dart';
import 'package:test/test.dart';


Duration wait = Duration(seconds: 1);


void main() {

  group('Keygen Misc Test', () {

    late String accountId;
    late String adminEmail;
    late String adminPassword;

    late KeygenClient client;

    late KeygenTokensApi tokensApi;
    late KeygenMiscApi miscApi;

    late Token adminToken;

    setUpAll(() async {

      DotEnv env = DotEnv(includePlatformEnvironment: true)
        ..load();

      accountId = env['KEYGEN_ACCOUNTID']!;
      adminEmail = env['KEYGEN_ADMIN_EMAIL']!;
      adminPassword = env['KEYGEN_ADMIN_PASSWORD']!;

      client = KeygenClient(accountId);
      tokensApi = KeygenTokensApi(client);
      miscApi = KeygenMiscApi(client);

      adminToken = await tokensApi.createToken(
        email: adminEmail,
        password: adminPassword,
      );

      await Future.delayed(wait);

    });

    tearDownAll(() async {

      await Future.delayed(wait);

      await tokensApi.revokeToken(
        token: adminToken,
        tokenToBeRevoked: adminToken,
      );

    });

    setUp(() async {

    });

    tearDown(() async {

    });

    test('who am i', () async {

      User user = await miscApi.whoAmI(
        token: adminToken,
      );

      expect(user.attributes.email, adminEmail);

    });

    //
    // may not write a test for forgotPassword because this requires an email
    // account to receive email
    //
    // test('forgot password', () async {
    //
    // });

  });
}
