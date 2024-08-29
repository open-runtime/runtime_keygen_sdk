import 'package:dotenv/dotenv.dart';
import 'package:keygen/runtime_keygen_sdk.dart';
import 'package:runtime_keygen_openapi/api.dart';
import 'package:test/test.dart';


// Why are there so many calls to `await Future.delayed(wait);` in the tests?
// See Tests section of README
Duration rateLimitDelay = Duration(seconds: 1);


// Miscellaneous actions
//
// See the README for more information about miscellaneous actions and how to
// use them.
void main() {

  group('Keygen Miscellaneous Test', () {

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

      await Future.delayed(rateLimitDelay);

    });

    tearDownAll(() async {

      await Future.delayed(rateLimitDelay);

      await tokensApi.revokeToken(
        token: adminToken,
        tokenToBeRevoked: adminToken,
      );

    });

    setUp(() async {

    });

    tearDown(() async {

    });

    // Retrieves the details of the currently authenticated bearer i.e. the
    // resource who the current API token belongs to.
    //
    // https://keygen.sh/docs/api/profiles/
    test('who am i', () async {

      dynamic resp = await miscApi.retrieveProfile(
        token: adminToken,
      );

      expect(resp is User, true);

      User user = resp as User;

      expect(user.attributes.email, adminEmail);

    });

    // may not write a test for forgotPassword because this requires an email
    // account to receive email
    //
    // test('forgot password', () async {
    //
    // });

  });
}
