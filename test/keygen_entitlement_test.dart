import 'package:dotenv/dotenv.dart';
import 'package:runtime_keygen_openapi/api.dart';
import 'package:runtime_keygen_sdk/runtime_keygen_sdk.dart';
import 'package:test/test.dart';


const String entitlementName = 'Example Entitlement';
const String newEntitlementName = 'Example Entitlement 2';
const String entitlementCode = 'EXAMPLE_ENTITLEMENT';

// Why are there so many calls to `await Future.delayed(wait);` in the tests?
// See Tests section of README
const Duration rateLimitDelay = Duration(seconds: 1);


// Entitlements can be attached to policies and to licenses to grant named
// "permissions" for things such as application features.
//
// See the README for more information about entitlements and how to use them.
//
// https://keygen.sh/docs/api/entitlements/
void main() {

  group('Keygen Entitlement Test', () {

    late String accountId;
    late String adminEmail;
    late String adminPassword;

    late KeygenClient client;

    late KeygenTokensApi tokensApi;
    late KeygenEntitlementsApi entitlementsApi;

    late Token adminToken;
    late Entitlement entitlement;

    setUpAll(() async {

      DotEnv env = DotEnv(includePlatformEnvironment: true)
        ..load();

      accountId = env['KEYGEN_ACCOUNTID']!;
      adminEmail = env['KEYGEN_ADMIN_EMAIL']!;
      adminPassword = env['KEYGEN_ADMIN_PASSWORD']!;

      client = KeygenClient(accountId);
      tokensApi = KeygenTokensApi(client);
      entitlementsApi = KeygenEntitlementsApi(client);

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

      entitlement = await entitlementsApi.createEntitlement(
        token: adminToken,
        name: entitlementName,
        code: entitlementCode,
      );

      await Future.delayed(rateLimitDelay);

    });

    tearDown(() async {

      await Future.delayed(rateLimitDelay);

      bool valid = await entitlementsApi.deleteEntitlement(
        token: adminToken,
        entitlement: entitlement,
      );

      expect(valid, true);

    });

    // Updates the specified entitlement resource by setting the values of the
    // parameters passed.
    //
    // https://keygen.sh/docs/api/entitlements/#entitlements-update
    test('update entitlement', () async {

      //
      // first verify that entitlement has entitlementName
      // then change name
      // then verify that entitlement now has newEntitlementName
      //

      String entitlementId = entitlement.id;

      Entitlement entitlement2 = await entitlementsApi.retrieveEntitlement(
        token: adminToken,
        entitlementId: entitlementId,
      );

      await Future.delayed(rateLimitDelay);

      expect(entitlement2.attributes.name, entitlementName);

      await entitlementsApi.updateEntitlement(
        token: adminToken,
        entitlement: entitlement2,
        name: newEntitlementName,
      );

      await Future.delayed(rateLimitDelay);

      entitlement2 = await entitlementsApi.retrieveEntitlement(
        token: adminToken,
        entitlementId: entitlementId,
      );

      await Future.delayed(rateLimitDelay);

      expect(entitlement2.attributes.name, newEntitlementName);

    });

    // Returns a list of entitlements.
    //
    // https://keygen.sh/docs/api/entitlements/#entitlements-list
    test('list entitlements', () async {

      List<Entitlement> entitlements = await entitlementsApi.listEntitlements(
        token: adminToken,
      );

      expect(entitlements.length, 1);
      expect(entitlements[0].id, entitlement.id);

    });

  });
}
