import 'package:keygen/runtime_keygen_sdk.dart';
import 'package:runtime_keygen_openapi/api.dart';

/// The product resource is used to segment policies and licenses by product, in the case where you sell multiple products.
///
/// https://keygen.sh/docs/api/products/
class KeygenProductsApi {

  /// The Keygen client for a specific account.
  final KeygenClient client;

  KeygenProductsApi(this.client);

  /// Creates a new product resource using
  /// the [token] that has admin privileges, and
  /// the [name] of the product.
  ///
  /// Returns the [Product] that was created.
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/products/#products-create
  Future<Product> createProduct({
    required Token token,
    required String name,
    String? url,
    CreateProductRequestDataAttributesDistributionStrategyEnum? distributionStrategyIn,
    List<String>? platformsIn,
    Map<String, String>? metadataIn,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    ProductsApi productsApi = ProductsApi(
      ApiClient(
        authentication: bearer,
      ),
    );

    //
    // QUIRK:
    // work-around issues with OpenAPI codegen
    //
    CreateProductRequestDataAttributesDistributionStrategyEnum distributionStrategy = distributionStrategyIn ?? CreateProductRequestDataAttributesDistributionStrategyEnum.LICENSED;
    List<String> platforms = platformsIn ?? [];
    Map<String, String> metadata = metadataIn ?? {};

    CreateProductRequest createProductRequest = CreateProductRequest(
      data: CreateProductRequestData(
        type: CreateProductRequestDataTypeEnum.products,
        attributes: CreateProductRequestDataAttributes(
          name: name,
          url: url,
          distributionStrategy: distributionStrategy,
          platforms: platforms,
          metadata: metadata,
        ),
      ),
    );

    try {

      CreateProductResponse? resp = await productsApi.createProduct(client.accountId, createProductRequest);

      if (resp == null) {
        throw KeygenError.fromString('createProduct returned null');
      }

      return resp.data;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }

  /// Generates a new product token resource using
  /// the [token] that has admin privileges, and
  /// the [product] to generate a token for.
  ///
  /// Returns the [KeygenToken] that was created.
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/products/#products-tokens
  Future<Token> createProductToken({
    required Token token,
    required Product product,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    ProductsApi productsApi = ProductsApi(
      ApiClient(
        authentication: bearer,
      ),
    );

    try {

      GenerateProductTokenResponse? resp = await productsApi.generateProductToken(client.accountId, product.id);

      if (resp == null) {
        throw KeygenError.fromString('generateProductToken returned null');
      }

      return resp.data;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }

  /// Permanently deletes a [product] using
  /// the [token] that has privileges to manage the resource.
  ///
  /// Returns `true` if successful.
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/products/#products-delete
  Future<bool> deleteProduct({
    required Token token,
    required Product product,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    ProductsApi productsApi = ProductsApi(
      ApiClient(
        authentication: bearer,
      ),
    );

    try {

      await productsApi.deleteProduct(client.accountId, product.id);

      return true;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }

  /// Returns a list of products using
  /// the [token] with admin privileges.
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/products/#products-list
  Future<List<Product>> listProducts({
    required Token token,
    Map<String, int>? page,
    int? limit,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    ProductsApi productsApi = ProductsApi(
      ApiClient(
        authentication: bearer,
      ),
    );

    try {

      ListProductsResponse? resp = await productsApi.listProducts(client.accountId,
        page: page,
        limit: limit,
      );

      if (resp == null) {
        throw KeygenError.fromString('listProducts returned null');
      }

      return resp.data;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }

  /// Retrieves the details of an existing [productId] using
  /// the [token] with admin privileges.
  ///
  /// Returns the [Product] that was retrieved.
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/products/#products-retrieve
  Future<Product> retrieveProduct({
    required Token token,
    required String productId,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    ProductsApi productsApi = ProductsApi(
      ApiClient(
        authentication: bearer,
      ),
    );

    try {

      RetrieveProductResponse? resp = await productsApi.retrieveProduct(client.accountId, productId);

      if (resp == null) {
        throw KeygenError.fromString('retrieveProduct returned null');
      }

      return resp.data;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }

  /// Updates the specified [product] resource by setting the values of the
  /// parameters passed using
  /// the [token] with privileges to manage the resource.
  ///
  /// Returns the [Product] that was updated.
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/products/#products-update
  Future<Product> updateProduct({
    required Token token,
    required Product product,
    String? name,
    String? url,
    UpdateProductRequestDataAttributesDistributionStrategyEnum? distributionStrategy,
    List<String>? platformsIn,
    Map<String, String>? metadataIn,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    ProductsApi productsApi = ProductsApi(
      ApiClient(
        authentication: bearer,
      ),
    );

    //
    // QUIRK:
    // work-around issues with OpenAPI codegen
    //
    List<String> platforms = platformsIn ?? [];
    Map<String, String> metadata = metadataIn ?? {};

    UpdateProductRequest updateProductRequest = UpdateProductRequest(
      data: UpdateProductRequestData(
        type: UpdateProductRequestDataTypeEnum.products,
        attributes: UpdateProductRequestDataAttributes(
          name: name,
          url: url,
          distributionStrategy: distributionStrategy,
          platforms: platforms,
          metadata: metadata,
        ),
      ),
    );

    try {

      UpdateProductResponse? resp = await productsApi.updateProduct(client.accountId, product.id,
        updateProductRequest: updateProductRequest,
      );

      if (resp == null) {
        throw KeygenError.fromString('updateProduct returned null');
      }

      return resp.data;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }
}
