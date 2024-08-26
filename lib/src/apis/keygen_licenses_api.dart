import 'package:keygen/keygen.dart';
import 'package:openapi/api.dart';

/// A license is an implementation of a product's policy.
///
/// https://keygen.sh/docs/api/licenses/
class KeygenLicensesApi {

  /// The Keygen client for a specific account.
  final KeygenClient client;

  KeygenLicensesApi(this.client);

  /// Creates a new license resource using
  /// the [token] that has privileges to manage the resource,
  /// the [policy] to implement for the license, and
  /// the [user] the license belongs to.
  ///
  /// Returns the [License] that was created.
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/licenses/#licenses-create
  Future<License> createLicense({
    required Token token,
    required Policy policy,
    required User user,
    String? name,
    String? key,
    DateTime? expiry,
    int? maxMachines,
    int? maxProcesses,
    int? maxCores,
    int? maxUses,
    bool? protected,
    bool? suspended,
    Map<String, String>? metadata,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    LicensesApi licensesApi = LicensesApi(
      ApiClient(
        authentication: bearer,
      ),
    );

    CreateLicenseRequest createLicenseRequest = CreateLicenseRequest(
      data: CreateLicenseRequestData(
        type: CreateLicenseRequestDataTypeEnum.licenses,
        attributes: CreateLicenseRequestDataAttributes(
          name: name,
          key: key,
          expiry: expiry,
          maxMachines: maxMachines,
          maxProcesses: maxProcesses,
          maxCores: maxCores,
          maxUses: maxUses,
          protected: protected,
          suspended: suspended,
          metadata: metadata,
        ),
        relationships: CreateLicenseRequestDataRelationships(
          policy: CreateLicenseRequestDataRelationshipsPolicy(
            data: CreateLicenseRequestDataRelationshipsPolicyData(
              type: CreateLicenseRequestDataRelationshipsPolicyDataTypeEnum.policies,
              id: policy.id,
            ),
          ),
          user: CreateLicenseRequestDataRelationshipsUser(
            data: CreateLicenseRequestDataRelationshipsUserData(
              type: CreateLicenseRequestDataRelationshipsUserDataTypeEnum.users,
              id: user.id,
            ),
          ),
        ),
      ),
    );

    try {

      CreateLicenseResponse? resp = await licensesApi.createLicense(client.accountId, createLicenseRequest);

      if (resp == null) {
        throw KeygenError.fromString('createLicense returned null');
      }

      return resp.data;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }

  /// Creates a license token for a [license] using
  /// the [token] that has privileges to create tokens for the resource.
  ///
  /// Returns the [KeygenToken] that was created.
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/licenses/#licenses-relationships-activation-tokens
  Future<Token> createLicenseToken({
    required Token token,
    required License license,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    LicensesApi licensesApi = LicensesApi(
      ApiClient(
        authentication: bearer,
      ),
    );

    try {

      CreateLicenseTokenResponse? resp = await licensesApi.createLicenseToken(client.accountId, license.id);

      if (resp == null) {
        throw KeygenError.fromString('createLicenseToken returned null');
      }

      return resp.data;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }

  /// Permanently deletes a [license] using
  /// the [token] that has privileges to manage the resource.
  ///
  /// Returns `true` if successful.
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/licenses/#licenses-delete
  Future<bool> deleteLicense({
    required Token token,
    required License license,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    LicensesApi licensesApi = LicensesApi(
      ApiClient(
        authentication: bearer,
      ),
    );

    try {

      await licensesApi.deleteLicense(client.accountId, license.id);

      return true;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }

  /// Retrieves the details of an existing [licenseId] using
  /// the [token] that has privileges to view the resource.
  ///
  /// Returns the [License] that was retrieved.
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/licenses/#licenses-retrieve
  Future<License> retrieveLicense({
    required Token token,
    required String licenseId,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    LicensesApi licensesApi = LicensesApi(
      ApiClient(
        authentication: bearer,
      ),
    );

    try {

      RetrieveLicenseResponse? resp = await licensesApi.retrieveLicense(client.accountId, licenseId);

      if (resp == null) {
        throw KeygenError.fromString('retrieveLicense returned null');
      }

      return resp.data;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }

  /// Checks-in a [license] using
  /// the [token] that has privileges to check-in the resource.
  ///
  /// Returns the [License] that was checked-in.
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/licenses/#licenses-actions-check-in
  Future<License> checkInLicense({
    required Token token,
    required License license,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    LicensesApi licensesApi = LicensesApi(
      ApiClient(
        authentication: bearer,
      ),
    );

    try {

      CheckInLicenseResponse? resp = await licensesApi.checkInLicense(client.accountId, license.id);

      if (resp == null) {
        throw KeygenError.fromString('checkInLicense returned null');
      }

      return resp.data;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }

  /// Validates a license using
  /// the [token] that has privileges to validate the resource, and
  /// the [licenseId] that is the identifier (UUID) or URL-safe key of the license to be validated.
  ///
  /// Returns the [ValidateLicenseResponse] that was returned by Keygen.
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/licenses/#licenses-actions-validate
  Future<ValidateLicenseResponse> validateLicenseById({
    required Token token,
    required String licenseId,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    LicensesApi licensesApi = LicensesApi(
      ApiClient(
        authentication: bearer,
      ),
    );

    try {

      ValidateLicenseResponse? resp = await licensesApi.validateLicense(client.accountId, licenseId);

      if (resp == null) {
        throw KeygenError.fromString('validateLicense returned null');
      }

      return resp;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }

  /// Validates a license key using
  /// the [licenseKey] to validate.
  ///
  /// Returns the [ValidateLicenseKeyResponse] that was returned by Keygen.
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/licenses/#licenses-actions-validate-key
  Future<ValidateLicenseKeyResponse> validateLicenseByKey({
    required String licenseKey,
  }) async {

    //
    // no authentication
    //

    LicensesApi licensesApi = LicensesApi(ApiClient());

    ValidateLicenseKeyRequest validateLicenseKeyRequest = ValidateLicenseKeyRequest(
      meta: ValidateLicenseKeyRequestMeta(
        key: licenseKey,
      ),
    );

    try {

      ValidateLicenseKeyResponse? resp = await licensesApi.validateLicenseKey(client.accountId,
        validateLicenseKeyRequest: validateLicenseKeyRequest,
      );

      if (resp == null) {
        throw KeygenError.fromString('validateLicenseKey returned null');
      }

      return resp;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }

  /// Changes a [license]'s policy relationship using
  /// the [token] that has privileges to manage the resource, and
  /// the [newPolicy] to be used.
  ///
  /// Returns `true` if successful.
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/licenses/#licenses-relationships-change-policy
  Future<License> changeLicensePolicy({
    required Token token,
    required License license,
    required Policy policy,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    LicensesApi licensesApi = LicensesApi(
      ApiClient(
        authentication: bearer,
      ),
    );

    ChangeLicensePolicyRequest changeLicensePolicyRequest = ChangeLicensePolicyRequest(
      data: CreateLicenseRequestDataRelationshipsPolicyData(
        type: CreateLicenseRequestDataRelationshipsPolicyDataTypeEnum.policies,
        id: policy.id,
      ),
    );

    try {

      ChangeLicensePolicyResponse? resp = await licensesApi.changeLicensePolicy(client.accountId, license.id, changeLicensePolicyRequest);

      if (resp == null) {
        throw KeygenError.fromString('changeLicensePolicy returned null');
      }

      return resp.data;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }
  
  /// Updates the specified [license] resource by setting the values of the
  /// parameters passed.
  /// the [token] that has privileges to manage the resource.
  ///
  /// Returns the [License] whose metadata was replaced.
  ///
  /// Throws [KeygenError] on error.
  ///
  /// Since the metadata attribute is simply a key-value store (object),
  /// all write operations will overwrite the entire object,
  /// so be sure to merge existing data on your end when performing updates.
  ///
  /// https://keygen.sh/docs/api/licenses/#licenses-update
  Future<License> updateLicense({
    required Token token,
    required License license,
    String? name,
    DateTime? expiry,
    int? maxMachines,
    int? maxProcesses,
    int? maxCores,
    int? maxUses,
    bool? protected,
    bool? suspended,
    Map<String, String>? metadata,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    LicensesApi licensesApi = LicensesApi(
      ApiClient(
        authentication: bearer,
      ),
    );

    UpdateLicenseRequest updateLicenseRequest = UpdateLicenseRequest(
      data: UpdateLicenseRequestData(
        type: UpdateLicenseRequestDataTypeEnum.licenses,
        attributes: UpdateLicenseRequestDataAttributes(
          name: name,
          expiry: expiry,
          maxMachines: maxMachines,
          maxProcesses: maxProcesses,
          maxCores: maxCores,
          maxUses: maxUses,
          protected: protected,
          suspended: suspended,
          metadata: metadata,
        ),
      ),
    );

    try {

      UpdateLicenseResponse? resp = await licensesApi.updateLicense(client.accountId, license.id,
        updateLicenseRequest: updateLicenseRequest,
      );

      if (resp == null) {
        throw KeygenError.fromString('updateLicense returned null');
      }

      return resp.data;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }

  /// Returns a list of licenses using
  /// the [token] with privileges to view the resources.
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/licenses/#licenses-list
  Future<List<License>> listLicenses({
    required Token token,
    Map<String, int>? page,
    int? limit,
    ListLicensesExpiresParameter? expires,
    String? status,
    bool? unassigned,
    String? product,
    String? policy,
    String? user,
    String? group,
    String? machine,
    Map<String, String>? metadata,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    LicensesApi licensesApi = LicensesApi(
      ApiClient(
        authentication: bearer,
      ),
    );

    try {

      ListLicensesResponse? resp = await licensesApi.listLicenses(client.accountId,
        page: page,
        limit: limit,
        expires: expires,
        status: status,
        unassigned: unassigned,
        product: product,
        policy: policy,
        user: user,
        group: group,
        machine: machine,
        metadata: metadata,
      );

      if (resp == null) {
        throw KeygenError.fromString('listLicenses returned null');
      }

      return resp.data;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }

  /// Temporarily suspends (bans) a [license] using
  /// the [token] with privileges to suspend the resource.
  ///
  /// Returns the suspended [License].
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/licenses/#licenses-actions-suspend
  Future<License> suspendLicense({
    required Token token,
    required License license,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    LicensesApi licensesApi = LicensesApi(
      ApiClient(
        authentication: bearer,
      ),
    );

    try {

      SuspendLicenseResponse? resp = await licensesApi.suspendLicense(client.accountId, license.id);

      if (resp == null) {
        throw KeygenError.fromString('suspendLicense returned null');
      }

      return resp.data;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }

  /// Reinstates a suspended [license] using
  /// the [token] with privileges to reinstate the resource.
  ///
  /// Returns the reinstated [License].
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/licenses/#licenses-actions-reinstate
  Future<License> reinstateLicense({
    required Token token,
    required License license,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    LicensesApi licensesApi = LicensesApi(
      ApiClient(
        authentication: bearer,
      ),
    );

    try {

      ReinstateLicenseResponse? resp = await licensesApi.reinstateLicense(client.accountId, license.id);

      if (resp == null) {
        throw KeygenError.fromString('reinstateLicense returned null');
      }

      return resp.data;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }

  /// Renews a [license] using
  /// the [token] with privileges to renew the resource.
  ///
  /// Returns the renewed [License].
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/licenses/#licenses-actions-renew
  Future<License> renewLicense({
    required Token token,
    required License license,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    LicensesApi licensesApi = LicensesApi(
      ApiClient(
        authentication: bearer,
      ),
    );

    try {

      RenewLicenseResponse? resp = await licensesApi.renewLicense(client.accountId, license.id);

      if (resp == null) {
        throw KeygenError.fromString('renewLicense returned null');
      }

      return resp.data;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }

  /// Prefer to use deleteLicense instead of revokeLicense
  Future<bool> revokeLicense({
    required Token token,
    required License license,
  }) async {
    throw KeygenError.fromString('prefer to use deleteLicense instead of revokeLicense');
  }

  /// attachUsers is currently missing form keygen-openapi.yml
  Future<Entitlement> attachUsers({
    required Token token,
    required License license,
    required List<User> users,
  }) async {
    throw KeygenError.fromString('attachUsers is currently missing form keygen-openapi.yml');
  }

  /// detachUsers is currently missing form keygen-openapi.yml
  Future<List<User>> detachUsers({
    required Token token,
    required License license,
    required List<User> users,
  }) async {
    throw KeygenError.fromString('detachUsers is currently missing form keygen-openapi.yml');
  }

  /// listUsers is currently missing form keygen-openapi.yml
  Future<Entitlement> listUsers({
    required Token token,
  }) async {
    throw KeygenError.fromString('listUsers is currently missing form keygen-openapi.yml');
  }

  /// Attaches [entitlements] to a [license] using
  /// the [token] with privileges to manage the resource.
  ///
  /// Returns the list of [Entitlement] that was attached.
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/licenses/#licenses-relationships-attach-entitlements
  Future<List<LicenseEntitlement>> attachLicenseEntitlements({
    required Token token,
    required License license,
    required List<Entitlement> entitlements,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    LicensesApi licensesApi = LicensesApi(
      ApiClient(
        authentication: bearer,
      ),
    );

    List<AttachPolicyEntitlementsRequestDataInner> data = entitlements.map(
            (entitlement) => AttachPolicyEntitlementsRequestDataInner(
              type: AttachPolicyEntitlementsRequestDataInnerTypeEnum.entitlements,
              id: entitlement.id,
            )
    ).toList();

    AttachLicenseEntitlementsRequest attachLicenseEntitlementsRequest = AttachLicenseEntitlementsRequest(
      data: data,
    );

    try {

      AttachLicenseEntitlementsResponse? resp = await licensesApi.attachLicenseEntitlements(client.accountId, license.id, attachLicenseEntitlementsRequest);

      if (resp == null) {
        throw KeygenError.fromString('attachLicenseEntitlements returned null');
      }

      return resp.data;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }

  /// Detaches [entitlements] from a [license] using
  /// the [token] with privileges to manage the resource.
  ///
  /// Returns the list of [Entitlement] that was detached.
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/licenses/#licenses-relationships-detach-entitlements
  Future<bool> detachLicenseEntitlements({
    required Token token,
    required License license,
    required List<Entitlement> entitlements,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    LicensesApi licensesApi = LicensesApi(
      ApiClient(
        authentication: bearer,
      ),
    );

    //
    // QUIRK:
    // DetachLicenseEntitlementsRequest takes a List of AttachPolicyEntitlementsRequestDataInner
    // This might seem confusing:
    // The attachPolicyEntitlements and detachLicenseEntitlements actions both take the same data types,
    // and openapi-generator has named that data type "AttachPolicyEntitlementsRequestDataInner"
    //

    List<AttachPolicyEntitlementsRequestDataInner> data = entitlements.map(
            (entitlement) => AttachPolicyEntitlementsRequestDataInner(
              type: AttachPolicyEntitlementsRequestDataInnerTypeEnum.entitlements,
              id: entitlement.id,
            )
    ).toList();

    DetachLicenseEntitlementsRequest detachLicenseEntitlementsRequest = DetachLicenseEntitlementsRequest(
      data: data,
    );

    try {

      await licensesApi.detachLicenseEntitlements(client.accountId, license.id, detachLicenseEntitlementsRequest);

      return true;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }

  /// Returns a list of entitlements attached to the [license] using
  /// the [token] with privileges to view the resource.
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/licenses/#licenses-relationships-list-entitlements
  Future<List<Entitlement>> listLicenseEntitlements({
    required Token token,
    required License license,
    Map<String, int>? page,
    int? limit,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    LicensesApi licensesApi = LicensesApi(
      ApiClient(
        authentication: bearer,
      ),
    );

    try {

      ListLicenseEntitlementsResponse? resp = await licensesApi.listLicenseEntitlements(client.accountId, license.id,
        page: page,
        limit: limit,
      );

      if (resp == null) {
        throw KeygenError.fromString('listLicenseEntitlements returned null');
      }

      return resp.data;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }

  /// Changes a [license]'s owner relationship using
  /// the [token] with privileges to manage the resource, and
  /// the [newOwner].
  ///
  /// Returns the [License] that was changed.
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/licenses/#licenses-relationships-change-owner
  Future<License> changeLicenseOwner({
    required Token token,
    required License license,
    required User owner,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    LicensesApi licensesApi = LicensesApi(
      ApiClient(
        authentication: bearer,
      ),
    );

    //
    // QUIRK:
    // This might seem confusing:
    // The createLicense and changeLicense actions both take the same data types,
    // and openapi-generator has named that data type "CreateLicenseRequestDataRelationshipsUserData"
    //

    ChangeLicenseUserRequest changeLicenseUserRequest = ChangeLicenseUserRequest(
      data: CreateLicenseRequestDataRelationshipsUserData(
        type: CreateLicenseRequestDataRelationshipsUserDataTypeEnum.users,
        id: owner.id,
      ),
    );

    try {

      ChangeLicenseUserResponse? resp = await licensesApi.changeLicenseUser(client.accountId, license.id, changeLicenseUserRequest);

      if (resp == null) {
        throw KeygenError.fromString('changeLicenseUser returned null');
      }

      return resp.data;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }
}
