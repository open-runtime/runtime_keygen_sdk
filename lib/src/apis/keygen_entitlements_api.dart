import 'package:keygen/keygen.dart';
import 'package:openapi/api.dart';

/// Entitlements can be attached to policies and to licenses to grant named
/// "permissions" for things such as application features.
///
/// https://keygen.sh/docs/api/entitlements/
class KeygenEntitlementsApi {

  /// The Keygen client for a specific account.
  final KeygenClient client;

  KeygenEntitlementsApi(this.client);

  /// Creates a new entitlement resource using
  /// the [token] that has admin privileges, and
  /// the [name] of the entitlement, and
  /// the unique [code] for the entitlement.
  ///
  /// Returns the created [Entitlement].
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/entitlements/#entitlements-create
  Future<Entitlement> createEntitlement({
    required Token token,
    required String name,
    required String code,
    Map<String, String>? metadata,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    EntitlementsApi entitlementsApi = EntitlementsApi(
      ApiClient(
        authentication: bearer,
      ),
    );

    CreateEntitlementRequest createEntitlementRequest = CreateEntitlementRequest(
      data: CreateEntitlementRequestData(
        type: CreateEntitlementRequestDataTypeEnum.entitlements,
        attributes: CreateEntitlementRequestDataAttributes(
          name: name,
          code: code,
          metadata: metadata,
        ),
      ),
    );

    try {

      CreateEntitlementResponse? resp = await entitlementsApi.createEntitlement(client.accountId, createEntitlementRequest);

      if (resp == null) {
        throw KeygenError.fromString('createEntitlement returned null');
      }

      return resp.data;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }

  /// Permanently deletes an entitlement using
  /// the [token] that has admin privileges, and
  /// the [entitlement] to be deleted.
  ///
  /// Returns `true` if successful.
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/entitlements/#entitlements-delete
  Future<bool> deleteEntitlement({
    required Token token,
    required Entitlement entitlement,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    EntitlementsApi entitlementsApi = EntitlementsApi(
      ApiClient(
        authentication: bearer,
      ),
    );

    try {

      await entitlementsApi.deleteEntitlement(client.accountId, entitlement.id);

      return true;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }

  /// Returns a list of entitlements using
  /// the [token] with privileges to view the resources.
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/entitlements/#entitlements-list
  Future<List<Entitlement>> listEntitlements({
    required Token token,
    Map<String, int>? page,
    int? limit,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    EntitlementsApi entitlementsApi = EntitlementsApi(
      ApiClient(
        authentication: bearer,
      ),
    );

    try {

      ListEntitlementsResponse? resp = await entitlementsApi.listEntitlements(client.accountId,
        page: page,
        limit: limit,
      );

      if (resp == null) {
        throw KeygenError.fromString('listEntitlements returned null');
      }

      return resp.data;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }

  /// Retrieves the details of an existing entitlement using
  /// the [token] with privileges to view the resources, and
  /// the [entitlementId] of the entitlement to be retrieved.
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/entitlements/#entitlements-retrieve
  Future<Entitlement> retrieveEntitlement({
    required Token token,
    required String entitlementId,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    EntitlementsApi entitlementsApi = EntitlementsApi(
      ApiClient(
        authentication: bearer,
      ),
    );

    try {

      RetrieveEntitlementResponse? resp = await entitlementsApi.retrieveEntitlement(client.accountId, entitlementId);

      if (resp == null) {
        throw KeygenError.fromString('retrieveEntitlement returned null');
      }

      return resp.data;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }

  /// Updates the specified [entitlement] resource by setting the values of the
  /// parameters passed using
  /// the [token] with privileges to manage the resource.
  ///
  /// Returns the updated [Entitlement].
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/entitlements/#entitlements-update
  Future<Entitlement> updateEntitlement({
    required Token token,
    required Entitlement entitlement,
    String? name,
    String? code,
    Map<String, String>? metadata,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    EntitlementsApi entitlementsApi = EntitlementsApi(
      ApiClient(
        authentication: bearer,
      ),
    );

    UpdateEntitlementRequest updateEntitlementRequest = UpdateEntitlementRequest(
      data: UpdateEntitlementRequestData(
        type: UpdateEntitlementRequestDataTypeEnum.entitlements,
        attributes: UpdateEntitlementRequestDataAttributes(
          name: name,
          code: code,
          metadata: metadata,
        ),
      ),
    );

    try {

      UpdateEntitlementResponse? resp = await entitlementsApi.updateEntitlement(client.accountId, entitlement.id,
        updateEntitlementRequest: updateEntitlementRequest,
      );

      if (resp == null) {
        throw KeygenError.fromString('updateEntitlement returned null');
      }

      return resp.data;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }
}
