import 'package:dotenv/dotenv.dart';
import 'package:keygen/keygen.dart';
import 'package:openapi/api.dart';
import 'package:test/test.dart';


String basicPolicyName = 'Basic Policy';
String productName = 'Product 1';
String badProductId = '50000000-18b0-40fb-b76e-646767e2e8cf';
String newBasicPolicyName = 'Basic Policy 2';
String entitlementName = 'Example Entitlement';
String entitlementCode = 'EXAMPLE_ENTITLEMENT';

Duration wait = Duration(seconds: 1);


void main() {

  group('Keygen Policy Test', () {

    late String accountId;
    late String adminEmail;
    late String adminPassword;

    late KeygenClient client;

    late KeygenTokensApi tokensApi;
    late KeygenProductsApi productsApi;
    late KeygenPoliciesApi policiesApi;
    late KeygenEntitlementsApi entitlementsApi;

    late Token adminToken;
    late Product product;
    late Token productToken;
    late Policy basicPolicy;

    setUpAll(() async {

      DotEnv env = DotEnv(includePlatformEnvironment: true)
        ..load();

      accountId = env['KEYGEN_ACCOUNTID']!;
      adminEmail = env['KEYGEN_ADMIN_EMAIL']!;
      adminPassword = env['KEYGEN_ADMIN_PASSWORD']!;

      client = KeygenClient(accountId);
      tokensApi = KeygenTokensApi(client);
      productsApi = KeygenProductsApi(client);
      policiesApi = KeygenPoliciesApi(client);
      entitlementsApi = KeygenEntitlementsApi(client);

      adminToken = await tokensApi.createToken(
        email: adminEmail,
        password: adminPassword,
      );

      await Future.delayed(wait);

      product = await productsApi.createProduct(
        token: adminToken,
        name: productName,
      );

      await Future.delayed(wait);

      productToken = await productsApi.createProductToken(
        token: adminToken,
        product: product,
      );

      await Future.delayed(wait);

    });

    tearDownAll(() async {

      await Future.delayed(wait);

      await tokensApi.revokeToken(
        token: adminToken,
        tokenToBeRevoked: productToken,
      );

      await Future.delayed(wait);

      await productsApi.deleteProduct(
        token: adminToken,
        product: product,
      );

      await Future.delayed(wait);

      await tokensApi.revokeToken(
        token: adminToken,
        tokenToBeRevoked: adminToken,
      );

    });

    setUp(() async {

      basicPolicy = await policiesApi.createPolicy(
        token: productToken,
        product: product,
        name: basicPolicyName,
      );

      await Future.delayed(wait);

    });

    tearDown(() async {

      await Future.delayed(wait);

      bool valid = await policiesApi.deletePolicy(
        token: productToken,
        policy: basicPolicy,
      );

      expect(valid, true);

    });

    test('bad product', () async {

      //
      // verify that bad product id causes an exception to be thrown
      //

      Product badProduct = Product(
        id: badProductId,
        type: product.type,
        attributes: product.attributes,
        relationships: product.relationships,
        links: product.links,
      );

      try {

         await policiesApi.createPolicy(
           token: productToken,
           product: badProduct,
           name: basicPolicyName,
        );

        fail('should have thrown');

      } on KeygenError catch(e) {

        expect(e.e?.code, 403);
      }

    });

    test('update policy', () async {

      //
      // first verify that policy has basicPolicyName
      // then change policy name
      // then verify that policy now has newBasicPolicyName
      //

      Policy policy2 = await policiesApi.retrievePolicy(
        token: adminToken,
        policyId: basicPolicy.id,
      );

      await Future.delayed(wait);

      expect(policy2.attributes.name, basicPolicyName);

      await policiesApi.updatePolicy(
        token: adminToken,
        policy: policy2,
        name: newBasicPolicyName,
      );

      await Future.delayed(wait);

      policy2 = await policiesApi.retrievePolicy(
        token: adminToken,
        policyId: basicPolicy.id,
      );

      expect(policy2.attributes.name, newBasicPolicyName);

    });

    test('list policies', () async {

      List<Policy> policies = await policiesApi.listPolicies(
        token: adminToken,
      );

      expect(policies.length, 1);
      expect(policies[0].id, basicPolicy.id);

    });

    //
    // This test found a bug in Keygen itself:
    // https://github.com/keygen-sh/keygen-api/pull/871
    //
    // There was a typo ('policies' was 'polices', which is insidious because
    // 'polices' is a word and a spell checker would not find this) and the
    // OpenAPI .yml file had the correct spelling, so the generated code was not
    // finding the correct key
    //
    test('list entitlements', () async {

      Entitlement entitlement = await entitlementsApi.createEntitlement(
        token: adminToken,
        name: entitlementName,
        code: entitlementCode,
      );

      await Future.delayed(wait);

      try {

        List<Entitlement> entitlements = await policiesApi.listPolicyEntitlements(
          token: adminToken,
          policy: basicPolicy,
        );

        await Future.delayed(wait);

        expect(entitlements.length, 0);

        await policiesApi.attachPolicyEntitlements(
          token: adminToken,
          policy: basicPolicy,
          entitlements: [ entitlement ],
        );

        await Future.delayed(wait);

        entitlements = await policiesApi.listPolicyEntitlements(
          token: adminToken,
          policy: basicPolicy,
        );

        await Future.delayed(wait);

        expect(entitlements.length, 1);
        expect(entitlements[0].id, entitlement.id);

        await Future.delayed(wait);

        await policiesApi.detachPolicyEntitlements(
          token: adminToken,
          policy: basicPolicy,
          entitlements: [ entitlement ],
        );

        await Future.delayed(wait);

        entitlements = await policiesApi.listPolicyEntitlements(
          token: adminToken,
          policy: basicPolicy,
        );

        await Future.delayed(wait);

        expect(entitlements.length, 0);

      } finally {

        await entitlementsApi.deleteEntitlement(
          token: adminToken,
          entitlement: entitlement,
        );
      }

    });

  });
}
