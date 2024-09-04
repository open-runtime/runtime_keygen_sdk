import 'package:runtime_keygen_openapi/api.dart';
import 'package:runtime_keygen_sdk/runtime_keygen_sdk.dart';

/// Machines can be used to track and manage where your users are allowed to use your product.
///
/// https://keygen.sh/docs/api/machines/
class KeygenMachinesApi {

  /// The Keygen client for a specific account.
  final KeygenClient client;

  KeygenMachinesApi(this.client);

  /// Creates, or activates, a new machine resource for a [license] using
  /// the [token] that has privileges to create the resource,
  /// the [fingerprint] of the machine, and
  /// the [platform] of the machine.
  ///
  /// Returns the [Machine] that was activated.
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/machines/#machines-create
  Future<Machine> activateMachine({
    required Token token,
    required License license,
    required String fingerprint,
    int? cores,
    String? name,
    String? ip,
    String? hostname,
    String? platform,
    Map<String, String>? metadata,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    MachinesApi machinesApi = MachinesApi(
      ApiClient(
        authentication: bearer,
      ),
    );

    ActivateMachineRequest activateMachineRequest = ActivateMachineRequest(
      data: ActivateMachineRequestData(
        type: ActivateMachineRequestDataTypeEnum.machines,
        attributes: ActivateMachineRequestDataAttributes(
          fingerprint: fingerprint,
          cores: cores,
          name: name,
          ip: ip,
          hostname: hostname,
          platform: platform,
          metadata: metadata,
        ),
        relationships: ActivateMachineRequestDataRelationships(
          license: ActivateMachineRequestDataRelationshipsLicense(
            data: ActivateMachineRequestDataRelationshipsLicenseData(
              type: ActivateMachineRequestDataRelationshipsLicenseDataTypeEnum.licenses,
              id: license.id,
            ),
          ),
        ),
      ),
    );

    try {

      ActivateMachineResponse? resp = await machinesApi.activateMachine(client.accountId, activateMachineRequest);

      if (resp == null) {
        throw KeygenError.fromString('activateMachine returned null');
      }

      return resp.data;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }

  /// Permanently deletes, or deactivates, a [machine] using
  /// the [token] that has privileges to manage the resource.
  ///
  /// Returns `true` if successful.
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/machines/#machines-delete
  Future<bool> deactivateMachine({
    required Token token,
    required Machine machine,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    MachinesApi machinesApi = MachinesApi(
      ApiClient(
        authentication: bearer,
      ),
    );

    try {

      await machinesApi.deactivateMachine(client.accountId, machine.id);

      return true;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }

  /// Returns a list of machines using
  /// the [token] with privileges to view the resources.
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/machines/#machines-list
  Future<List<Machine>> listMachines({
    required Token token,
    Map<String, int>? page,
    int? limit,
    String? fingerprint,
    String? ip,
    String? hostname,
    String? product,
    String? policy,
    String? license,
    String? key,
    String? user,
    String? group,
    Map<String, String>? metadata,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    MachinesApi machinesApi = MachinesApi(
      ApiClient(
        authentication: bearer,
      ),
    );

    try {

      ListMachinesResponse? resp = await machinesApi.listMachines(client.accountId,
        page: page,
        limit: limit,
        fingerprint: fingerprint,
        ip: ip,
        hostname: hostname,
        product: product,
        policy: policy,
        license: license,
        key: key,
        user: user,
        group: group,
        metadata: metadata,
      );

      if (resp == null) {
        throw KeygenError.fromString('listMachines returned null');
      }

      return resp.data;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }

  /// Begins or maintains a [machine] heartbeat monitor using
  /// the [token] with privileges to ping the resource's heartbeat.
  ///
  /// Returns the [Machine] that is monitored.
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/machines/#machines-actions-ping
  Future<Machine> pingHeartbeat({
    required Token token,
    required Machine machine,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    MachinesApi machinesApi = MachinesApi(
      ApiClient(
        authentication: bearer,
      ),
    );

    try {

      PingMachineResponse? resp = await machinesApi.pingMachine(client.accountId, machine.id);

      if (resp == null) {
        throw KeygenError.fromString('pingMachine returned null');
      }

      return resp.data;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }

  /// Resets and stops the [machine]'s heartbeat monitor using
  /// the [token] with privileges to reset the resource's heartbeat.
  ///
  /// Returns the [Machine] that was reset.
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/machines/#machines-actions-reset
  Future<Machine> resetHeartbeat({
    required Token token,
    required Machine machine,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    MachinesApi machinesApi = MachinesApi(
      ApiClient(
        authentication: bearer,
      ),
    );

    try {

      ResetMachineResponse? resp = await machinesApi.resetMachine(client.accountId, machine.id);

      if (resp == null) {
        throw KeygenError.fromString('resetMachine returned null');
      }

      return resp.data;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }

  /// changeOwner is currently missing from keygen-openapi.yml
  Future<Machine> changeOwner({
    required Token token,
    required Machine machine,
    required User owner,
  }) async {
    throw KeygenError.fromString('changeOwner is currently missing from keygen-openapi.yml');
  }

  /// Retrieves the details of an existing machine using
  /// the [token] with privileges to view the resource, and
  /// the [machineId] of the machine.
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/machines/#machines-retrieve
  Future<Machine> retrieveMachine({
    required Token token,
    required String machineId,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    MachinesApi machinesApi = MachinesApi(
      ApiClient(
        authentication: bearer,
      ),
    );

    try {

      RetrieveMachineResponse? resp = await machinesApi.retrieveMachine(client.accountId, machineId);

      if (resp == null) {
        throw KeygenError.fromString('retrieveMachine returned null');
      }

      return resp.data;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }

  /// Updates the specified [machine] resource by setting the values of the
  /// parameters passed using
  /// the [token] with privileges to manage the resource.
  ///
  /// Returns the [Machine] that was updated.
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/machines/#machines-update
  Future<Machine> updateMachine({
    required Token token,
    required Machine machine,
    String? name,
    String? ip,
    String? hostname,
    String? platform,
    int? cores,
    Map<String, String>? metadata,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    MachinesApi machinesApi = MachinesApi(
      ApiClient(
          authentication: bearer,
      ),
    );

    UpdateMachineRequest updateMachineRequest = UpdateMachineRequest(
      data: UpdateMachineRequestData(
        type: UpdateMachineRequestDataTypeEnum.machines,
        attributes: UpdateMachineRequestDataAttributes(
          name: name,
          ip: ip,
          hostname: hostname,
          platform: platform,
          cores: cores,
          metadata: metadata,
        ),
      ),
    );

    try {

      UpdateMachineResponse? resp = await machinesApi.updateMachine(client.accountId, machine.id,
        updateMachineRequest: updateMachineRequest,
      );

      if (resp == null) {
        throw KeygenError.fromString('updateMachine returned null');
      }

      return resp.data;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }
}
