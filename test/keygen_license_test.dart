import 'package:dotenv/dotenv.dart';
import 'package:keygen/runtime_keygen_sdk.dart';
import 'package:runtime_keygen_openapi/api.dart';
import 'package:test/test.dart';


const String basicPolicyName = 'Basic Policy';
const String proPolicyName = 'Pro Policy';
const String productName = 'Product 1';
const String emailJohnDoe = 'john@doe.com';
const String licenseName = 'License Name';
const String newLicenseName = 'License Name 2';
const String entitlementName = 'Example Entitlement';
const String entitlementCode = 'EXAMPLE_ENTITLEMENT';
const int durationDaySeconds = 86400;

// Why are there so many calls to `await Future.delayed(wait);` in the tests?
// See Tests section of README
Duration rateLimitDelay = Duration(seconds: 1);


// Licenses are used to grant access to your software.
//
// See the README for more information about licenses and how to use them.
//
// https://keygen.sh/docs/api/licenses/
void main() {

  group('Keygen License Test', () {

    late String accountId;
    late String adminEmail;
    late String adminPassword;

    late KeygenClient client;

    late KeygenTokensApi tokensApi;
    late KeygenProductsApi productsApi;
    late KeygenUsersApi usersApi;
    late KeygenPoliciesApi policiesApi;
    late KeygenLicensesApi licensesApi;
    late KeygenEntitlementsApi entitlementsApi;
    late KeygenMiscApi miscApi;

    late Token adminToken;
    late Product product;
    late Token productToken;
    late User user;
    late Policy basicPolicy;
    late License license;
    late DateTime licenseCreationTime;

    setUpAll(() async {

      DotEnv env = DotEnv(includePlatformEnvironment: true)
        ..load();

      accountId = env['KEYGEN_ACCOUNTID']!;
      adminEmail = env['KEYGEN_ADMIN_EMAIL']!;
      adminPassword = env['KEYGEN_ADMIN_PASSWORD']!;

      client = KeygenClient(accountId);
      tokensApi = KeygenTokensApi(client);
      productsApi = KeygenProductsApi(client);
      usersApi = KeygenUsersApi(client);
      policiesApi = KeygenPoliciesApi(client);
      licensesApi = KeygenLicensesApi(client);
      entitlementsApi = KeygenEntitlementsApi(client);
      miscApi = KeygenMiscApi(client);

      adminToken = await tokensApi.createToken(
        email: adminEmail,
        password: adminPassword,
      );

      await Future.delayed(rateLimitDelay);

      product = await productsApi.createProduct(
        token: adminToken,
        name: productName,
      );

      await Future.delayed(rateLimitDelay);

      productToken = await productsApi.createProductToken(
        token: adminToken,
        product: product,
      );

      await Future.delayed(rateLimitDelay);

      user = await usersApi.createUser(
        token: adminToken,
        email: emailJohnDoe,
      );

      await Future.delayed(rateLimitDelay);

      basicPolicy = await policiesApi.createPolicy(
        token: productToken,
        product: product,
        name: basicPolicyName,
        duration: durationDaySeconds,
      );

      await Future.delayed(rateLimitDelay);

    });

    tearDownAll(() async {

      await Future.delayed(rateLimitDelay);

      await policiesApi.deletePolicy(
        token: adminToken,
        policy: basicPolicy,
      );

      await Future.delayed(rateLimitDelay);

      await usersApi.deleteUser(
        token: adminToken,
        user: user,
      );

      await Future.delayed(rateLimitDelay);

      await tokensApi.revokeToken(
        token: adminToken,
        tokenToBeRevoked: productToken,
      );

      await Future.delayed(rateLimitDelay);

      await productsApi.deleteProduct(
        token: adminToken,
        product: product,
      );

      await Future.delayed(rateLimitDelay);

      await tokensApi.revokeToken(
        token: adminToken,
        tokenToBeRevoked: adminToken,
      );

    });

    setUp(() async {

      //
      // expiry is 10 minutes from now
      //

      licenseCreationTime = DateTime.now();

      license = await licensesApi.createLicense(
        token: productToken,
        policy: basicPolicy,
        user: user,
        name: licenseName,
        expiry: licenseCreationTime.add(Duration(minutes: 10))
      );

      await Future.delayed(rateLimitDelay);

    });

    tearDown(() async {

      await Future.delayed(rateLimitDelay);

      bool valid = await licensesApi.deleteLicense(
        token: productToken,
        license: license,
      );

      expect(valid, true);

    });

    // Updates the specified license resource by setting the values of the
    // parameters passed.
    //
    // https://keygen.sh/docs/api/licenses/#licenses-update
    test('update license', () async {

      //
      // first verify that license has licenseName
      // then change name
      // then verify that license now has newLicenseName
      //

      License license2 = await licensesApi.retrieveLicense(
        token: adminToken,
        licenseId: license.id,
      );

      await Future.delayed(rateLimitDelay);

      expect(license2.attributes.name, licenseName);

      await licensesApi.updateLicense(
        token: adminToken,
        license: license2,
        name: newLicenseName,
      );

      await Future.delayed(rateLimitDelay);

      License license3 = await licensesApi.retrieveLicense(
        token: adminToken,
        licenseId: license.id,
      );

      expect(license3.attributes.name, newLicenseName);

    });

    // Returns a list of licenses.
    //
    // https://keygen.sh/docs/api/licenses/#licenses-list
    test('list licenses', () async {

      List<License> licenses = await licensesApi.listLicenses(
        token: adminToken,
      );

      expect(licenses.length, 1);
      expect(licenses[0], license);

    });

    // Validates a license.
    //
    // https://keygen.sh/docs/api/licenses/#licenses-actions-validate
    test('validate license by id', () async {

      ValidateLicenseResponse resp = await licensesApi.validateLicenseById(
        token: adminToken,
        licenseId: license.id,
      );

      expect(resp.meta.valid, true);

    });

    // Validates a license key.
    //
    // https://keygen.sh/docs/api/licenses/#licenses-actions-validate-key
    test('validate license by key', () async {

      ValidateLicenseKeyResponse resp = await licensesApi.validateLicenseByKey(
        licenseKey: license.attributes.key,
      );

      expect(resp.meta.valid, true);

    });

    // Temporarily suspends (bans) a license.
    //
    // https://keygen.sh/docs/api/licenses/#licenses-actions-suspend
    test('suspend license', () async {

      ValidateLicenseResponse resp = await licensesApi.validateLicenseById(
        token: adminToken,
        licenseId: license.id,
      );

      await Future.delayed(rateLimitDelay);

      expect(resp.meta.code, 'VALID');

      await licensesApi.suspendLicense(
        token: adminToken,
        license: license,
      );

      await Future.delayed(rateLimitDelay);

      resp = await licensesApi.validateLicenseById(
        token: adminToken,
        licenseId: license.id,
      );

      await Future.delayed(rateLimitDelay);

      expect(resp.meta.code, 'SUSPENDED');

      await licensesApi.reinstateLicense(
        token: adminToken,
        license: license,
      );

      await Future.delayed(rateLimitDelay);

      resp = await licensesApi.validateLicenseById(
        token: adminToken,
        licenseId: license.id,
      );

      expect(resp.meta.code, 'VALID');

    });

    // Renews a license.
    //
    // https://keygen.sh/docs/api/licenses/#licenses-actions-renew
    test('renew license', () async {

      //
      // first verify that license expiry is within 1 day
      // then renew license
      // then verify that license expiry is now 2 weeks in the future
      //

      License license2 = await licensesApi.retrieveLicense(
        token: adminToken,
        licenseId: license.id,
      );

      await Future.delayed(rateLimitDelay);

      DateTime expiry = license2.attributes.expiry!;

      int diffInMinutes = DateTime.now().difference(expiry).inMinutes;

      expect(diffInMinutes <= 10, true);

      await licensesApi.renewLicense(
        token: adminToken,
        license: license,
      );

      await Future.delayed(rateLimitDelay);

      license2 = await licensesApi.retrieveLicense(
        token: adminToken,
        licenseId: license.id,
      );

      expiry = license2.attributes.expiry!;

      diffInMinutes = expiry.difference(DateTime.now()).inMinutes;

      expect(100 <= diffInMinutes, true);

    });

    // Prefer to use deleteLicense instead of revokeLicense
    test('revoke license', () async {

      try {

        await licensesApi.revokeLicense(
          token: adminToken,
          license: license,
        );

        fail('should have thrown');

      } on KeygenError catch (e) {

        //
        // 'prefer to use deleteLicense instead of revokeLicense'
        //
        expect(e.msg, isNotNull);
      }

    });

    // Checks-in a license.
    //
    // https://keygen.sh/docs/api/licenses/#licenses-actions-check-in
    test('checkin license', () async {

      //
      // this throws because:
      // "cannot be checked in because the policy does not require it"
      //

      try {

        await licensesApi.checkInLicense(
          token: productToken,
          license: license,
        );

        fail('should have thrown');

      } on KeygenError catch (e) {

        expect(e.e?.code, 422);
      }
    });

    // Creates a license token for a license.
    //
    // https://keygen.sh/docs/api/licenses/#licenses-relationships-activation-tokens
    test('create license token', () async {

      Token licenseToken = await licensesApi.createLicenseToken(
        token: adminToken,
        license: license,
      );

      await Future.delayed(rateLimitDelay);

      // FIXME: currently throws
      await miscApi.whoAmI(
        token: licenseToken,
      );

      try {

        expect(licenseToken.attributes.token, startsWith('activ-'));

      } finally {

        await tokensApi.revokeToken(
          token: adminToken,
          tokenToBeRevoked: licenseToken,
        );
      }

    });

    // attachUsers is currently missing form keygen-openapi.yml
    // detachUsers is currently missing form keygen-openapi.yml
    // listUsers is currently missing form keygen-openapi.yml
    test('list users', () async {

      try {

        await licensesApi.attachUsers(
          token: adminToken,
          license: license,
          users: [],
        );

        fail('should have thrown');

      } on KeygenError catch (e) {

        expect(e.msg, isNotNull);
      }

      await Future.delayed(rateLimitDelay);

      try {

        await licensesApi.detachUsers(
          token: adminToken,
          license: license,
          users: [],
        );

        fail('should have thrown');

      } on KeygenError catch (e) {

        expect(e.msg, isNotNull);
      }

      await Future.delayed(rateLimitDelay);

      try {

        await licensesApi.listUsers(
          token: adminToken,
        );

        fail('should have thrown');

      } on KeygenError catch (e) {

        expect(e.msg, isNotNull);
      }

    });

    // Returns a list of entitlements attached to the license.
    //
    // https://keygen.sh/docs/api/licenses/#licenses-relationships-list-entitlements
    test('list entitlements', () async {

      Entitlement entitlement = await entitlementsApi.createEntitlement(
        token: adminToken,
        name: entitlementName,
        code: entitlementCode,
      );

      await Future.delayed(rateLimitDelay);

      try {

        List<Entitlement> entitlements = await licensesApi.listLicenseEntitlements(
          token: adminToken,
          license: license,
        );

        await Future.delayed(rateLimitDelay);

        expect(entitlements.length, 0);

        await licensesApi.attachLicenseEntitlements(
          token: adminToken,
          license: license,
          entitlements: [ entitlement ],
        );

        await Future.delayed(rateLimitDelay);

        entitlements = await licensesApi.listLicenseEntitlements(
          token: adminToken,
          license: license,
        );

        await Future.delayed(rateLimitDelay);

        expect(entitlements.length, 1);
        expect(entitlements[0].id, entitlement.id);

        await licensesApi.detachLicenseEntitlements(
          token: adminToken,
          license: license,
          entitlements: [ entitlement ],
        );

        await Future.delayed(rateLimitDelay);

        entitlements = await licensesApi.listLicenseEntitlements(
          token: adminToken,
          license: license,
        );

        await Future.delayed(rateLimitDelay);

        expect(entitlements.length, 0);

      } finally {

        await entitlementsApi.deleteEntitlement(
          token: adminToken,
          entitlement: entitlement,
        );
      }

    });

    // Changes a license's policy relationship.
    //
    // https://keygen.sh/docs/api/licenses/#licenses-relationships-change-policy
    test('change license policy', () async {

      //
      // first verify that license implements Basic Policy
      // then change policy
      // then verify that license now implements Pro Policy
      //

      Policy proPolicy = await policiesApi.createPolicy(
        token: productToken,
        product: product,
        name: proPolicyName,
      );

      await Future.delayed(rateLimitDelay);

      try {

        License license2 = await licensesApi.retrieveLicense(
          token: adminToken,
          licenseId: license.id,
        );

        await Future.delayed(rateLimitDelay);

        expect(license2.relationships.policy.data.id, basicPolicy.id);

        await licensesApi.changeLicensePolicy(
          token: productToken,
          license: license,
          policy: proPolicy,
        );

        await Future.delayed(rateLimitDelay);

        license2 = await licensesApi.retrieveLicense(
          token: adminToken,
          licenseId: license.id,
        );

        await Future.delayed(rateLimitDelay);

        expect(license2.relationships.policy.data.id, proPolicy.id);

      } finally {

        await policiesApi.deletePolicy(
          token: adminToken,
          policy: proPolicy,
        );
      }

    });

  });
}
