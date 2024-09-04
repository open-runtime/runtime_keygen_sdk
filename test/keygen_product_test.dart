import 'package:dotenv/dotenv.dart';
import 'package:runtime_keygen_openapi/api.dart';
import 'package:runtime_keygen_sdk/runtime_keygen_sdk.dart';
import 'package:test/test.dart';


const String productName = 'Product 1';
const String badAdminToken = 'admin-6c247b57d6e8e0000000000000000b6847cf387d6415137766b635bc262bb64dv3';
const String newProductName = 'Product 2';

// Why are there so many calls to `await Future.delayed(wait);` in the tests?
// See Tests section of README
Duration rateLimitDelay = Duration(seconds: 1);


// Products are used to segment policies and licenses, in the case where you
// sell multiple products.
//
// See the README for more information about products and how to use them.
//
// https://keygen.sh/docs/api/products/
void main() {

  group('Keygen Product Test', () {

    late String accountId;
    late String adminEmail;
    late String adminPassword;

    late KeygenClient client;

    late KeygenTokensApi tokensApi;
    late KeygenProductsApi productsApi;
    late KeygenMiscApi miscApi;

    late Token adminToken;
    late Product product;

    setUpAll(() async {

      DotEnv env = DotEnv(includePlatformEnvironment: true)
        ..load();

      accountId = env['KEYGEN_ACCOUNTID']!;
      adminEmail = env['KEYGEN_ADMIN_EMAIL']!;
      adminPassword = env['KEYGEN_ADMIN_PASSWORD']!;

      client = KeygenClient(accountId);
      tokensApi = KeygenTokensApi(client);
      productsApi = KeygenProductsApi(client);
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

      product = await productsApi.createProduct(
        token: adminToken,
        name: productName,
      );

      await Future.delayed(rateLimitDelay);

    });

    tearDown(() async {

      await Future.delayed(rateLimitDelay);

      bool valid = await productsApi.deleteProduct(
        token: adminToken,
        product: product,
      );

      expect(valid, true);

    });

    test('bad admin token', () async {

      //
      // verify that bad admin token causes exception to be thrown
      //

      TokenAttributes badTokenAttributes = TokenAttributes(
        kind: adminToken.attributes.kind,
        token: badAdminToken,
        name: adminToken.attributes.name,
        expiry: adminToken.attributes.expiry,
        maxActivations: adminToken.attributes.maxActivations,
        activations: adminToken.attributes.activations,
        maxDeactivations: adminToken.attributes.maxDeactivations,
        deactivations: adminToken.attributes.deactivations,
        created: adminToken.attributes.created,
        updated: adminToken.attributes.updated,
      );

      Token badToken = Token(
        id: adminToken.id,
        type: adminToken.type,
        attributes: badTokenAttributes,
        relationships: adminToken.relationships,
      );

      try {

        await productsApi.createProduct(
          token: badToken,
          name: productName,
        );

        fail('should have thrown');

      } on KeygenError catch (e) {

        expect(e.e?.code, 401);
      }

    });

    // Updates the specified product resource by setting the values of the
    // parameters passed.
    //
    // https://keygen.sh/docs/api/products/#products-update
    test('update product', () async {

      //
      // first verify that product has productName
      // then change product name
      // then verify that product now has newProductName
      //

      Product product2 = await productsApi.retrieveProduct(
        token: adminToken,
        productId: product.id,
      );

      await Future.delayed(rateLimitDelay);

      expect(product2.attributes.name, productName);

      await productsApi.updateProduct(
        token: adminToken,
        product: product2,
        name: newProductName,
      );

      await Future.delayed(rateLimitDelay);

      product2 = await productsApi.retrieveProduct(
        token: adminToken,
        productId: product.id,
      );

      expect(product2.attributes.name, newProductName);

    });

    // Returns a list of products.
    //
    // https://keygen.sh/docs/api/products/#products-list
    test('list products', () async {

      List<Product> products = await productsApi.listProducts(
        token: adminToken,
      );

      expect(products.length, 1);
      expect(products[0].id, product.id);

    });

    // Generates a new product token resource.
    //
    // https://keygen.sh/docs/api/products/#products-tokens
    test('create product token', () async {

      Token productToken = await productsApi.createProductToken(
        token: adminToken,
        product: product,
      );

      await Future.delayed(rateLimitDelay);

      // FIXME: currently throws
      await miscApi.whoAmI(
        token: productToken,
      );

      try {

        expect(productToken.attributes.token, startsWith('prod-'));

      } finally {

        await tokensApi.revokeToken(
          token: adminToken,
          tokenToBeRevoked: productToken,
        );
      }

    });

  });
}
