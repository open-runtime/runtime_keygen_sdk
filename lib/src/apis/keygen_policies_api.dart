import 'package:runtime_keygen_openapi/api.dart';
import 'package:runtime_keygen_sdk/runtime_keygen_sdk.dart';

/// Your policies define the different types of licenses that a given product offers.
///
/// https://keygen.sh/docs/api/policies/
class KeygenPoliciesApi {

  /// The Keygen client for a specific account.
  final KeygenClient client;

  KeygenPoliciesApi(this.client);

  /// Creates a new policy resource using
  /// the [token] that has privileges to manage the resource,
  /// the [product] the policy is for, and
  /// the [name] of the policy.
  ///
  /// Returns the [KeygenPolicy] that was created.
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/policies/#policies-create
  Future<Policy> createPolicy({
    required Token token,
    required Product product,
    required String name,
    int? duration,
    CreatePolicyRequestDataAttributesSchemeEnum? scheme,
    bool strict = false,
    bool floating = false,
    bool requireProductScope = false,
    bool requirePolicyScope = false,
    bool requireMachineScope = false,
    bool requireFingerprintScope = false,
    bool requireUserScope = false,
    bool requireChecksumScope = false,
    bool requireVersionScope = false,
    bool requireCheckIn = false,
    CreatePolicyRequestDataAttributesCheckInIntervalEnum? checkInInterval,
    int? checkInIntervalCount,
    bool usePool = false,
    int? maxMachines,
    int? maxProcesses,
    int? maxCores,
    int? maxUses,
    bool? protected,
    bool requireHeartbeat = false,
    int? heartbeatDuration,
    CreatePolicyRequestDataAttributesHeartbeatCullStrategyEnum heartbeatCullStrategy = CreatePolicyRequestDataAttributesHeartbeatCullStrategyEnum.DEACTIVATE_DEAD,
    CreatePolicyRequestDataAttributesHeartbeatResurrectionStrategyEnum heartbeatResurrectionStrategy = CreatePolicyRequestDataAttributesHeartbeatResurrectionStrategyEnum.NO_REVIVE,
    CreatePolicyRequestDataAttributesHeartbeatBasisEnum? heartbeatBasis,
    CreatePolicyRequestDataAttributesMachineUniquenessStrategyEnum machineUniquenessStrategy = CreatePolicyRequestDataAttributesMachineUniquenessStrategyEnum.UNIQUE_PER_LICENSE,
    CreatePolicyRequestDataAttributesMachineMatchingStrategyEnum machineMatchingStrategy = CreatePolicyRequestDataAttributesMachineMatchingStrategyEnum.MATCH_ANY,
    CreatePolicyRequestDataAttributesExpirationStrategyEnum expirationStrategy = CreatePolicyRequestDataAttributesExpirationStrategyEnum.RESTRICT_ACCESS,
    CreatePolicyRequestDataAttributesExpirationBasisEnum expirationBasis = CreatePolicyRequestDataAttributesExpirationBasisEnum.FROM_CREATION,
    CreatePolicyRequestDataAttributesTransferStrategyEnum transferStrategy = CreatePolicyRequestDataAttributesTransferStrategyEnum.KEEP_EXPIRY,
    CreatePolicyRequestDataAttributesAuthenticationStrategyEnum authenticationStrategy = CreatePolicyRequestDataAttributesAuthenticationStrategyEnum.TOKEN,
    CreatePolicyRequestDataAttributesMachineLeasingStrategyEnum? machineLeasingStrategy,
    CreatePolicyRequestDataAttributesProcessLeasingStrategyEnum? processLeasingStrategy,
    CreatePolicyRequestDataAttributesOverageStrategyEnum overageStrategy = CreatePolicyRequestDataAttributesOverageStrategyEnum.NO_OVERAGE,
    Map<String, String>? metadata,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    PoliciesApi policiesApi = PoliciesApi(
      ApiClient(
        authentication: bearer,
      ),
    );

    CreatePolicyRequest createPolicyRequest = CreatePolicyRequest(
      data: CreatePolicyRequestData(
        type: CreatePolicyRequestDataTypeEnum.policies,
        attributes: CreatePolicyRequestDataAttributes(
          name: name,
          duration: duration,
          scheme: scheme,
          strict: strict,
          floating: floating,
          requireProductScope: requireProductScope,
          requirePolicyScope: requirePolicyScope,
          requireMachineScope: requireMachineScope,
          requireFingerprintScope: requireFingerprintScope,
          requireUserScope: requireUserScope,
          requireChecksumScope: requireChecksumScope,
          requireVersionScope: requireVersionScope,
          requireCheckIn: requireCheckIn,
          checkInInterval: checkInInterval,
          checkInIntervalCount: checkInIntervalCount,
          usePool: usePool,
          maxMachines: maxMachines,
          maxProcesses: maxProcesses,
          maxCores: maxCores,
          maxUses: maxUses,
          protected: protected,
          requireHeartbeat: requireHeartbeat,
          heartbeatDuration: heartbeatDuration,
          heartbeatCullStrategy: heartbeatCullStrategy,
          heartbeatResurrectionStrategy: heartbeatResurrectionStrategy,
          heartbeatBasis: heartbeatBasis,
          machineUniquenessStrategy: machineUniquenessStrategy,
          machineMatchingStrategy: machineMatchingStrategy,
          expirationStrategy: expirationStrategy,
          expirationBasis: expirationBasis,
          transferStrategy: transferStrategy,
          authenticationStrategy: authenticationStrategy,
          machineLeasingStrategy: machineLeasingStrategy,
          processLeasingStrategy: processLeasingStrategy,
          overageStrategy: overageStrategy,
          metadata: metadata,
        ),
        relationships: CreatePolicyRequestDataRelationships(
          product: CreatePolicyRequestDataRelationshipsProduct(
            data: CreatePolicyRequestDataRelationshipsProductData(
              type: CreatePolicyRequestDataRelationshipsProductDataTypeEnum.products,
              id: product.id,
            ),
          ),
        ),
      ),
    );

    try {

      CreatePolicyResponse? resp = await policiesApi.createPolicy(client.accountId, createPolicyRequest);

      if (resp == null) {
        throw KeygenError.fromString('createPolicy returned null');
      }

      return resp.data;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }

  /// Permanently deletes a [policy] using
  /// the [token] that has privileges to manage the resource.
  ///
  /// Returns `true` if successful.
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/policies/#policies-delete
  Future<bool> deletePolicy({
    required Token token,
    required Policy policy,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    PoliciesApi policiesApi = PoliciesApi(
      ApiClient(
        authentication: bearer,
      ),
    );

    try {

      await policiesApi.deletePolicy(client.accountId, policy.id);

      return true;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }

  /// Attaches [entitlements] to a [policy] using
  /// the [token] with privileges to manage the resource.
  ///
  /// Returns the list of [PolicyEntitlement] that was attached.
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/policies/#policies-relationships-attach-entitlements
  Future<List<PolicyEntitlement>> attachPolicyEntitlements({
    required Token token,
    required Policy policy,
    required List<Entitlement> entitlements,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    PoliciesApi policiesApi = PoliciesApi(
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

    AttachPolicyEntitlementsRequest attachPolicyEntitlementsRequest = AttachPolicyEntitlementsRequest(
      data: data,
    );

    try {

      AttachPolicyEntitlementsResponse? resp = await policiesApi.attachPolicyEntitlements(client.accountId, policy.id, attachPolicyEntitlementsRequest);

      if (resp == null) {
        throw KeygenError.fromString('attachPolicyEntitlements returned null');
      }

      return resp.data;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }

  /// Detaches [entitlements] from a [policy] using
  /// the [token] with privileges to manage the resource.
  ///
  /// Returns the list of [Entitlement] that was detached.
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/policies/#policies-relationships-detach-entitlements
  Future<bool> detachPolicyEntitlements({
    required Token token,
    required Policy policy,
    required List<Entitlement> entitlements,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    PoliciesApi policiesApi = PoliciesApi(
      ApiClient(
        authentication: bearer,
      ),
    );

    //
    // QUIRK:
    // DetachPolicyEntitlementsRequest takes a List of AttachPolicyEntitlementsRequestDataInner
    // This might seem confusing:
    // The attachPolicyEntitlements and detachPolicyEntitlements actions both take the same data types,
    // and openapi-generator has named that data type "AttachPolicyEntitlementsRequestDataInner"
    //

    List<AttachPolicyEntitlementsRequestDataInner> data = entitlements.map(
            (entitlement) => AttachPolicyEntitlementsRequestDataInner(
              type: AttachPolicyEntitlementsRequestDataInnerTypeEnum.entitlements,
              id: entitlement.id,
            )
    ).toList();

    DetachPolicyEntitlementsRequest detachPolicyEntitlementsRequest = DetachPolicyEntitlementsRequest(
      data: data,
    );

    try {

      await policiesApi.detachPolicyEntitlements(client.accountId, policy.id, detachPolicyEntitlementsRequest);

      return true;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }

  /// Returns a list of entitlements attached to the [policy] using
  /// the [token] with privileges to view the resource.
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/policies/#policies-relationships-list-entitlements
  Future<List<Entitlement>> listPolicyEntitlements({
    required Token token,
    required Policy policy,
    Map<String, int>? page,
    int? limit,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    PoliciesApi policiesApi = PoliciesApi(
      ApiClient(
        authentication: bearer,
      ),
    );

    try {

      ListPolicyEntitlementsResponse? resp = await policiesApi.listPolicyEntitlements(client.accountId, policy.id,
        page: page,
        limit: limit,
      );

      if (resp == null) {
        throw KeygenError.fromString('listPolicyEntitlements returned null');
      }

      return resp.data;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }

  /// Returns a list of policies using
  /// the [token] with privileges to view the resources.
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/policies/#policies-list
  Future<List<Policy>> listPolicies({
    required Token token,
    Map<String, int>? page,
    int? limit,
    String? product,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    PoliciesApi policiesApi = PoliciesApi(
      ApiClient(
        authentication: bearer,
      ),
    );

    try {

      ListPoliciesResponse? resp = await policiesApi.listPolicies(client.accountId,
        page: page,
        limit: limit,
        product: product,
      );

      if (resp == null) {
        throw KeygenError.fromString('listPolicies returned null');
      }

      return resp.data;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }

  /// Retrieves the details of an existing [policyId] using
  /// the [token] with privileges to view the resource.
  ///
  /// Returns the [Policy] that was retrieved.
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/policies/#policies-retrieve
  Future<Policy> retrievePolicy({
    required Token token,
    required String policyId,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    PoliciesApi policiesApi = PoliciesApi(
      ApiClient(
        authentication: bearer,
      ),
    );

    try {

      RetrievePolicyResponse? resp = await policiesApi.retrievePolicy(client.accountId, policyId);

      if (resp == null) {
        throw KeygenError.fromString('retrievePolicy returned null');
      }

      return resp.data;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }

  /// Updates the specified [policy] resource by setting the values of the
  /// parameters passed using
  /// the [token] with privileges to manage the resource.
  ///
  /// Returns the [Policy] that was updated.
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/policies/#policies-update
  Future<Policy> updatePolicy({
    required Token token,
    required Policy policy,
    String? name,
    int? duration,
    bool? strict,
    bool? floating,
    bool? requireProductScope,
    bool? requirePolicyScope,
    bool? requireMachineScope,
    bool? requireFingerprintScope,
    bool? requireUserScope,
    bool? requireChecksumScope,
    bool? requireVersionScope,
    bool? requireCheckIn,
    UpdatePolicyRequestDataAttributesCheckInIntervalEnum? checkInInterval,
    int? checkInIntervalCount,
    int? maxMachines,
    int? maxProcesses,
    int? maxCores,
    int? maxUses,
    bool? protected,
    bool? requireHeartbeat,
    int? heartbeatDuration,
    UpdatePolicyRequestDataAttributesHeartbeatCullStrategyEnum? heartbeatCullStrategy,
    UpdatePolicyRequestDataAttributesHeartbeatResurrectionStrategyEnum? heartbeatResurrectionStrategy,
    UpdatePolicyRequestDataAttributesHeartbeatBasisEnum? heartbeatBasis,
    UpdatePolicyRequestDataAttributesMachineUniquenessStrategyEnum? machineUniquenessStrategy,
    UpdatePolicyRequestDataAttributesMachineMatchingStrategyEnum? machineMatchingStrategy,
    UpdatePolicyRequestDataAttributesExpirationStrategyEnum? expirationStrategy,
    UpdatePolicyRequestDataAttributesExpirationBasisEnum? expirationBasis,
    UpdatePolicyRequestDataAttributesTransferStrategyEnum? transferStrategy,
    UpdatePolicyRequestDataAttributesAuthenticationStrategyEnum? authenticationStrategy,
    UpdatePolicyRequestDataAttributesMachineLeasingStrategyEnum? machineLeasingStrategy,
    UpdatePolicyRequestDataAttributesProcessLeasingStrategyEnum? processLeasingStrategy,
    UpdatePolicyRequestDataAttributesOverageStrategyEnum? overageStrategy,
    Map<String, String>? metadata,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    PoliciesApi policiesApi = PoliciesApi(
      ApiClient(
        authentication: bearer,
      ),
    );

    UpdatePolicyRequest updatePolicyRequest = UpdatePolicyRequest(
      data: UpdatePolicyRequestData(
        type: UpdatePolicyRequestDataTypeEnum.policies,
        attributes: UpdatePolicyRequestDataAttributes(
          name: name,
          duration: duration,
          strict: strict,
          floating: floating,
          requireProductScope: requireProductScope,
          requirePolicyScope: requirePolicyScope,
          requireMachineScope: requireMachineScope,
          requireFingerprintScope: requireFingerprintScope,
          requireUserScope: requireUserScope,
          requireChecksumScope: requireChecksumScope,
          requireVersionScope: requireVersionScope,
          requireCheckIn: requireCheckIn,
          checkInInterval: checkInInterval,
          checkInIntervalCount: checkInIntervalCount,
          maxMachines: maxMachines,
          maxProcesses: maxProcesses,
          maxCores: maxCores,
          maxUses: maxUses,
          protected: protected,
          requireHeartbeat: requireHeartbeat,
          heartbeatDuration: heartbeatDuration,
          heartbeatCullStrategy: heartbeatCullStrategy,
          heartbeatResurrectionStrategy: heartbeatResurrectionStrategy,
          heartbeatBasis: heartbeatBasis,
          machineUniquenessStrategy: machineUniquenessStrategy,
          machineMatchingStrategy: machineMatchingStrategy,
          expirationStrategy: expirationStrategy,
          expirationBasis: expirationBasis,
          transferStrategy: transferStrategy,
          authenticationStrategy: authenticationStrategy,
          machineLeasingStrategy: machineLeasingStrategy,
          processLeasingStrategy: processLeasingStrategy,
          overageStrategy: overageStrategy,
          metadata: metadata,
        ),
      ),
    );

    try {

      UpdatePolicyResponse? resp = await policiesApi.updatePolicy(client.accountId, policy.id,
        updatePolicyRequest: updatePolicyRequest,
      );

      if (resp == null) {
        throw KeygenError.fromString('updatePolicy returned null');
      }

      return resp.data;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }
}
