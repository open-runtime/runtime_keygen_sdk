import 'package:dotenv/dotenv.dart';
import 'package:keygen/keygen.dart';
import 'package:openapi/api.dart';
import 'package:test/test.dart';


String entitlementName = 'Example Entitlement';
String newEntitlementName = 'Example Entitlement 2';
String entitlementCode = 'EXAMPLE_ENTITLEMENT';

Duration wait = Duration(seconds: 1);


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

      entitlement = await entitlementsApi.createEntitlement(
        token: adminToken,
        name: entitlementName,
        code: entitlementCode,
      );

      await Future.delayed(wait);

    });

    tearDown(() async {

      await Future.delayed(wait);

      bool valid = await entitlementsApi.deleteEntitlement(
        token: adminToken,
        entitlement: entitlement,
      );

      expect(valid, true);

    });

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

      await Future.delayed(wait);

      expect(entitlement2.attributes.name, entitlementName);

      await entitlementsApi.updateEntitlement(
        token: adminToken,
        entitlement: entitlement2,
        name: newEntitlementName,
      );

      await Future.delayed(wait);

      entitlement2 = await entitlementsApi.retrieveEntitlement(
        token: adminToken,
        entitlementId: entitlementId,
      );

      await Future.delayed(wait);

      expect(entitlement2.attributes.name, newEntitlementName);

    });

    test('list entitlements', () async {

      List<Entitlement> entitlements = await entitlementsApi.listEntitlements(
        token: adminToken,
      );

      expect(entitlements.length, 1);
      expect(entitlements[0].id, entitlement.id);

    });

  });
}
