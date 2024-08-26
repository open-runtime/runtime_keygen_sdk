import 'package:dotenv/dotenv.dart';
import 'package:keygen/runtime_keygen_sdk.dart';
import 'package:runtime_keygen_openapi/api.dart';
import 'package:test/test.dart';


const String badAdminPassword = 'badpassword1234';

Duration wait = Duration(seconds: 1);


// Tokens are used by Keygen for authenticating API requests.
//
// See the README for more information about tokens and how to use them.
//
// https://keygen.sh/docs/api/tokens/
void main() {

  group('Keygen Token Test', () {

    late String accountId;
    late String adminEmail;
    late String adminPassword;

    late KeygenClient client;
    late KeygenTokensApi tokensApi;

    setUpAll(() async {

      DotEnv env = DotEnv(includePlatformEnvironment: true)
        ..load();

      accountId = env['KEYGEN_ACCOUNTID']!;
      adminEmail = env['KEYGEN_ADMIN_EMAIL']!;
      adminPassword = env['KEYGEN_ADMIN_PASSWORD']!;

      client = KeygenClient(accountId);
      tokensApi = KeygenTokensApi(client);

    });

    tearDownAll(() async {

    });

    setUp(() async {

    });

    tearDown(() async {

    });

    test('wrong password', () async {

      //
      // verify that wrong password causes exception to be thrown
      //

      try {

        await tokensApi.createToken(
          email: adminEmail,
          password: badAdminPassword,
        );

        fail('should have thrown');

      } on KeygenError catch(e) {

        expect(e.e?.code, 401);
      }

    });

    // Retrieves the details of an existing [tokenId].
    //
    // https://keygen.sh/docs/api/tokens/#tokens-retrieve
    test('retrieve token', () async {

      Token adminToken = await tokensApi.createToken(
        email: adminEmail,
        password: adminPassword,
      );

      await Future.delayed(wait);

      try {

        Token token2 = await tokensApi.retrieveToken(
          token: adminToken,
          tokenToRetrieveId: adminToken.id,
        );

        await Future.delayed(wait);

        expect(token2.id, adminToken.id);

      } finally {

        await tokensApi.revokeToken(
          token: adminToken,
          tokenToBeRevoked: adminToken,
        );
      }

    });

    // Regenerates an existing tokenToRegenerateId resource.
    //
    // https://keygen.sh/docs/api/tokens/#tokens-regenerate
    test('regenerate token', () async {

      Token adminToken = await tokensApi.createToken(
        email: adminEmail,
        password: adminPassword,
      );

      await Future.delayed(wait);

      //
      // nothing much to test here
      //

      Token newAdminToken = await tokensApi.regenerateToken(
        token: adminToken,
        tokenToRegenerateId: adminToken.id,
      );

      await tokensApi.revokeToken(
        token: newAdminToken,
        tokenToBeRevoked: newAdminToken,
      );

    });

    // Returns a list of tokens.
    //
    // https://keygen.sh/docs/api/tokens/#tokens-list
    test('list tokens', () async {

      Token adminToken = await tokensApi.createToken(
        email: adminEmail,
        password: adminPassword,
      );

      await Future.delayed(wait);

      try {

        List<Token> tokens = await tokensApi.listTokens(
          token: adminToken,
        );

        //
        // it is 2 because of the existing admin token
        //
        expect(tokens.length, 2);
        //
        // The tokens are returned sorted by creation date, with the most recent tokens appearing first.
        //
        expect(tokens[0].id, adminToken.id);

      } finally {

        await tokensApi.revokeToken(
          token: adminToken,
          tokenToBeRevoked: adminToken,
        );
      }

    });

  });
}
