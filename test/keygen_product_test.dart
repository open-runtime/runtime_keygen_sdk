import 'package:dotenv/dotenv.dart';
import 'package:keygen/keygen.dart';
import 'package:openapi/api.dart';
import 'package:test/test.dart';


String productName = 'Product 1';
String badAdminToken = 'admin-6c247b57d6e8e0000000000000000b6847cf387d6415137766b635bc262bb64dv3';
String newProductName = 'Product 2';

Duration wait = Duration(seconds: 1);


void main() {

  group('Keygen Product Test', () {

    late String accountId;
    late String adminEmail;
    late String adminPassword;

    late KeygenClient client;

    late KeygenTokensApi tokensApi;
    late KeygenProductsApi productsApi;

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

      product = await productsApi.createProduct(
        token: adminToken,
        name: productName,
      );

      await Future.delayed(wait);

    });

    tearDown(() async {

      await Future.delayed(wait);

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

      await Future.delayed(wait);

      expect(product2.attributes.name, productName);

      await productsApi.updateProduct(
        token: adminToken,
        product: product2,
        name: newProductName,
      );

      await Future.delayed(wait);

      product2 = await productsApi.retrieveProduct(
        token: adminToken,
        productId: product.id,
      );

      expect(product2.attributes.name, newProductName);

    });

    test('list products', () async {

      List<Product> products = await productsApi.listProducts(
        token: adminToken,
      );

      expect(products.length, 1);
      expect(products[0].id, product.id);

    });

    test('create product token', () async {

      Token productToken = await productsApi.createProductToken(
        token: adminToken,
        product: product,
      );

      await Future.delayed(wait);

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
